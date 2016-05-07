//
//  ViewController.m
//  THTravelHeart
//
//  Created by Hsping on 16/4/23.
//  Copyright © 2016年 TianHan. All rights reserved.
//

#import "ViewController.h"
#import "CloudPOIAnnotation.h"
#import "DetailViewController.h"
#import "PinYinForObjc.h"
#import "ChineseInclude.h"
#import <AMapSearchKit/AMapSearchObj.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import <MAMapKit/MAMapKit.h>
#define GeoPlaceHolder @"名称"
#import "NearSearchViewController.h"
#import "StorageMgr.h"
@interface ViewController ()<UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDataSource,UITableViewDelegate, AMapSearchDelegate>
{
    UITableView *_tableview;
}


@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapCloudAPI *cloudAPI;
@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)UISearchDisplayController *displayController;
@property(nonatomic,strong)NSMutableArray *tips;
@property(nonatomic,strong)NSMutableArray *objectsForShow;
@property (nonatomic, strong) AMapSearchAPI *search;
@end

@implementation ViewController
@synthesize tips=_tips;
@synthesize searchBar=_searchBar;
@synthesize displayController=_displayController;
@synthesize search=_search;
@synthesize mapView = _mapView;
#pragma mark - Utility
-(void)searchGeocodeWithKey:(NSString *)key adcode:(NSString *)adcode
{
    if(key.length==0)
    {
        return;
    }
    AMapCloudPlaceAroundSearchRequest *request = [[AMapCloudPlaceAroundSearchRequest alloc] init];
    request.tableID = (NSString *)tableID;//在数据管理台中取得
    double radius = 30000;
    AMapCloudPoint *centerPoint = [AMapCloudPoint locationWithLatitude:31.57 longitude:120.27];
    [request setOffset:100];
    //设置中心点和半径
    [request setRadius:radius];
    [request setCenter:centerPoint];
    request.keywords = key;
    
//    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
//    geo.address = key;
//    if(adcode.length>0)
//    {
//        geo.city=@[adcode];
//    }
    [self.cloudAPI AMapCloudPlaceAroundSearch:request];
    
//    [self.search AMapGeocodeSearch:geo];
}
-(void)searchTipsWthKey:(NSString *)key
{
    if(key.length==0)
    {
        return;
    }
    AMapInputTipsSearchRequest *tips=[[AMapInputTipsSearchRequest alloc]init];
    tips.keywords=key;
    [self.search AMapInputTipsSearch:tips];
}
-(void)clear
{
    [self.mapView removeAnnotations:self.mapView.annotations];
}

- (void)clearAndSearchGeocodeWithKey:(NSString *)key adcode:(NSString *)adcode
{
    /* 清除annotation. */
    [self clear];
    
    [self searchGeocodeWithKey:key adcode:adcode];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _locationManager = [[CLLocationManager alloc] init];
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
#ifdef __IPHONE_8_0
        [_locationManager requestWhenInUseAuthorization];
#endif
    }
    
    self.search = [[AMapSearchAPI alloc] initWithSearchKey:[MAMapServices sharedServices].apiKey Delegate:self];
    //self.search.delegate = self;
    
    if (self.mapView == nil) {
        self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64 + 40, UI_SCREEN_W, UI_SCREEN_H - 40 - 50 - 64)];
    }
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = 1;
    _objectsForShow=[NSMutableArray new];
    [self.view addSubview:self.mapView];
    
    //[AMapSearchServices sharedServices].apiKey = (NSString *)APIKey;
    self.cloudAPI = [[AMapCloudAPI alloc] initWithCloudKey:(NSString *)APIKey delegate:self];
    //self.cloudAPI.delegate = self;
    
    [self cloudPlaceAroundSearch];
    [super viewDidLoad];
    
    [self initSearchBar];
    
    [self initSearchDisplay];

}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    if (searchText.length == 0)
    {
        [_tableview reloadData];
        [_tableview setHidden:YES];
    }
    else
    {
        _tips = [[NSMutableArray alloc]init];
        if (searchBar.text.length>0&&![ChineseInclude inIncludeChineseInString:   searchBar.text]) {
            for (int i=0; i<_tips.count; i++) {
                if ([ChineseInclude inIncludeChineseInString:_tips[i]]) {
                    NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:_tips[i]];
                    NSRange titleResult=[tempPinYinStr rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
                    if (titleResult.length>0) {
                        [_tips addObject:_tips[i]];
                    }
                    NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:_tips[i]];
                    NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
                    if (titleHeadResult.length>0) {
                        [_tips addObject:_tips[i]];
                    }
                }
                else {
                    NSRange titleResult=[_tips[i] rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
                    if (titleResult.length>0) {
                        [_tips addObject:_tips[i]];
                    }
                }
            }
            
        } else if (searchBar.text.length>0&&[ChineseInclude inIncludeChineseInString:searchBar.text]) {
            for (NSString *tempStr in _tips) {
                NSRange titleResult=[tempStr rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [_tips addObject:tempStr];
                }
            }
        }
        
        [_tableview reloadData];
        [_tableview setHidden:NO];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)cloudPlaceAroundSearch
{
    AMapCloudPlaceAroundSearchRequest *placeAround = [[AMapCloudPlaceAroundSearchRequest alloc] init];
    [placeAround setTableID:(NSString *)tableID];
    
    double radius = 30000;
    AMapCloudPoint *centerPoint = [AMapCloudPoint locationWithLatitude:31.57 longitude:120.27];
    [placeAround setOffset:100];
    //设置中心点和半径
    [placeAround setRadius:radius];
    [placeAround setCenter:centerPoint];
    
    //设置关键字
    //[placeAround setKeywords:@"公园"];
    
    //过滤条件数组filters的含义等同于SQL语句:WHERE _address = "文津街1" AND _id BETWEEN 20 AND 40
    //    NSArray *filters = [[NSArray alloc] initWithObjects:@"_id:[20,70]", @"_address:文津街", nil];
    //    [placeAround setFilter:filters];
    
    //设置排序方式
    //    [placeAround setSortFields:@"_id"];
    //    [placeAround setSortType:AMapCloudSortType_DESC];
    
    //设置每页记录数和当前页数
    //[placeAround setOffset:80];
    //[placeAround setPage:2];
    
    [self.cloudAPI AMapCloudPlaceAroundSearch:placeAround];
    //[self addMACircleViewWithCenter:CLLocationCoordinate2DMake(centerPoint.latitude, centerPoint.longitude) radius:radius];
   
}

- (void)addMACircleViewWithCenter:(CLLocationCoordinate2D)center radius:(double)radius
{
    MACircle *circle = [MACircle circleWithCenterCoordinate:center radius:radius];
    
    [self.mapView addOverlay:circle];
}

#pragma mark - AMapCloudSearchDelegate

- (void)onCloudPlaceAroundSearchDone:(AMapCloudPlaceAroundSearchRequest *)request response:(AMapCloudSearchResponse *)response
{
    NSLog(@"status:%ld ,info:%@ ,count:%ld",(long)response.status, response.info, (long)response.count);
    
    [self addAnnotationsWithPOIs:[response POIs]];
}

- (void)addAnnotationsWithPOIs:(NSArray *)pois
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    for (AMapCloudPOI *aPOI in pois)
    {
        NSLog(@"这个事吗%@",aPOI);
        [_objectsForShow addObject:aPOI];
        CloudPOIAnnotation *ann = [[CloudPOIAnnotation alloc] initWithCloudPOI:aPOI];
        [self.mapView addAnnotation:ann];
    }
    
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
}

#pragma mark - AMapSearchDelegate

/* 地理编码回调.*/
//- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
//{
//    if (response.geocodes.count == 0)
//    {
//        return;
//    }
//    
//    NSMutableArray *annotations = [NSMutableArray array];
//    
//    [response.geocodes enumerateObjectsUsingBlock:^(AMapGeocode *obj, NSUInteger idx, BOOL *stop) {
//        GeocodeAnnotation *geocodeAnnotation = [[GeocodeAnnotation alloc] initWithGeocode:obj];
//        
//        [annotations addObject:geocodeAnnotation];
//    }];
//    
//    if (annotations.count == 1)
//    {
//        [self.mapView setCenterCoordinate:[annotations[0] coordinate] animated:YES];
//    }
//    else
//    {
//        [self.mapView setVisibleMapRect:[CommonUtility minMapRectForAnnotations:annotations]
//                               animated:YES];
//    }
//    
//    [self.mapView addAnnotations:annotations];
//}

#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[CloudPOIAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"PlaceAroundSearchIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.canShowCallout   = YES;
        annotationView.animatesDrop     = NO;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        return annotationView;
    }
    
    return nil;
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MACircle class]])
    {
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        
        circleRenderer.lineWidth        = 1.f;
        circleRenderer.lineDashPattern  = @[@"5", @"5"];
        circleRenderer.strokeColor      = [UIColor blueColor];
        circleRenderer.fillColor        = [UIColor colorWithRed:1 green:0 blue:0 alpha:.3];
        
        return circleRenderer;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([view.annotation isKindOfClass:[CloudPOIAnnotation class]])
    {
        [self gotoDetailForCloudPOI:[(CloudPOIAnnotation *)view.annotation cloudPOI]];
    }
}

- (void)gotoDetailForCloudPOI:(AMapCloudPOI *)cloudPOI
{
    if (cloudPOI != nil)
    {
        
        
       DetailViewController *detail = [Utilities getStoryboardInstance:@"Main" byIdentity:@"detail"];
        detail.cloudPOI = cloudPOI;
        
        [self.navigationController pushViewController:detail animated:YES];
//        AMapCloudPOIDetailViewController *cloudPOIDetailViewController = [[AMapCloudPOIDetailViewController alloc] init];
//        cloudPOIDetailViewController.cloudPOI = cloudPOI;
//        
//        [self.navigationController pushViewController:cloudPOIDetailViewController animated:YES];
    }
}


#pragma mark - AMapSearchDelegate


- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    [self.tips setArray:response.tips];
    
    [self.displayController.searchResultsTableView reloadData];
}
#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *key = searchBar.text;
    
    [self clearAndSearchGeocodeWithKey:key adcode:nil];
    //[self searchTipsWthKey:key];
    
    [self.displayController setActive:NO animated:NO];
    
    self.searchBar.placeholder = key;
}
#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self searchTipsWthKey:searchString];
    return YES;
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tips.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tipCellIdentifier = @"tipCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tipCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:tipCellIdentifier];
    }
    
    AMapTip *tip = self.tips[indexPath.row];
    
    cell.textLabel.text = tip.name;
    cell.detailTextLabel.text = tip.adcode;
    
    return cell;
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMapTip *tip = self.tips[indexPath.row];
    
    [self clearAndSearchGeocodeWithKey:tip.name adcode:tip.adcode];
    
    [self.displayController setActive:NO animated:NO];
    
    self.searchBar.placeholder = tip.name;
}
#pragma mark - Initialization

- (void)initSearchBar
{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44)];
    self.searchBar.barStyle     = UIBarStyleBlack;
    self.searchBar.translucent  = YES;
    self.searchBar.delegate     = self;
    self.searchBar.placeholder  = GeoPlaceHolder;
    self.searchBar.keyboardType = UIKeyboardTypeDefault;
    
    [self.view addSubview:self.searchBar];
}

- (void)initSearchDisplay
{
    self.displayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.displayController.delegate                = self;
    self.displayController.searchResultsDataSource = self;
    self.displayController.searchResultsDelegate   = self;
}
#pragma mark - Life Cycle

- (id)init
{
    if (self = [super init])
    {
        self.tips = [NSMutableArray array];
    }
    
    return self;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"fujin"]) {
        //获得当前用户选中细胞的行数
        [[StorageMgr singletonStorageMgr]addKey:@"SignUpSuccessfully" andValue:_objectsForShow];
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


//当按下键盘右下角的按钮执行这个方法，收起键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}
//当按下旁白部分收起键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
