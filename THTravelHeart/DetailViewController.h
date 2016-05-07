//
//  DetailViewController.h
//  THTravelHeart
//
//  Created by Hsping on 16/4/23.
//  Copyright © 2016年 TianHan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) AMapCloudPOI *cloudPOI;
@property(nonatomic,strong)NSMutableArray *tip1;
- (IBAction)CallAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *adressLbl;


@property (strong, nonatomic) UIImageView *zoomIV;

@end
