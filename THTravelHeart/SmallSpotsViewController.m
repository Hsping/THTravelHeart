//
//  SmallSpotsViewController.m
//  THTravelHeart
//
//  Created by Hsping on 16/4/23.
//  Copyright © 2016年 TianHan. All rights reserved.
//

#import "SmallSpotsViewController.h"
#import "CloudPOIAnnotation.h"
#import "DetailViewController.h"
#import "PinYinForObjc.h"
#import "ChineseInclude.h"
#import <AMapSearchKit/AMapSearchObj.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import <MAMapKit/MAMapKit.h>
#import "StorageMgr.h"
@interface SmallSpotsViewController ()

@end

@implementation SmallSpotsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _spots=[NSMutableArray new];
   _spots=[[StorageMgr singletonStorageMgr]objectForKey:@"SignUpSuccessfully"];
   
    NSLog(@"zxczxczxczxczxczxcfdbgdsgsdgsdgdsgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdg%@",_spots);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _spots.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
   AMapTip *tip= _spots[indexPath.row];
    cell.textLabel.text=tip.name;
   
  
   
    return cell;
}
@end
