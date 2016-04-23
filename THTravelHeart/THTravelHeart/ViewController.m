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
@interface ViewController ()<MAMapViewDelegate, AMapCloudDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapCloudAPI *cloudAPI;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _locationManager = [[CLLocationManager alloc] init];
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
#ifdef __IPHONE_8_0
        [_locationManager requestWhenInUseAuthorization];
#endif
    }
    
    if (self.mapView == nil) {
        self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64 + 40, UI_SCREEN_W, UI_SCREEN_H - 40 - 50 - 64)];
    }
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = 1;
    [self.view addSubview:self.mapView];
    
    self.cloudAPI = [[AMapCloudAPI alloc] initWithCloudKey:(NSString *)APIKey delegate:self];
    //self.cloudAPI.delegate = self;
    
    [self cloudPlaceAroundSearch];

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
        NSLog(@"%@",aPOI);
        
        CloudPOIAnnotation *ann = [[CloudPOIAnnotation alloc] initWithCloudPOI:aPOI];
        [self.mapView addAnnotation:ann];
    }
    
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
}

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
        
       DetailViewController *avi=[Utilities getStoryboardInstance:@"Main" byIdentity:@"detail"];
        [self.navigationController pushViewController:avi animated:YES];

//        AMapCloudPOIDetailViewController *cloudPOIDetailViewController = [[AMapCloudPOIDetailViewController alloc] init];
//        cloudPOIDetailViewController.cloudPOI = cloudPOI;
//        
//        [self.navigationController pushViewController:cloudPOIDetailViewController animated:YES];
    }
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
