//
//  SmallSpotsViewController.h
//  THTravelHeart
//
//  Created by Hsping on 16/4/23.
//  Copyright © 2016年 TianHan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmallSpotsViewController : UIViewController
@property (nonatomic, strong) AMapCloudPOI *cloudPOI;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *spots;
@end
