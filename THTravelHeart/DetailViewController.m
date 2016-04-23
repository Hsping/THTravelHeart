//
//  DetailViewController.m
//  THTravelHeart
//
//  Created by Hsping on 16/4/23.
//  Copyright © 2016年 TianHan. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _image2.userInteractionEnabled=YES;
    UITapGestureRecognizer *photoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photo)];
    [self.image2 addGestureRecognizer:photoTap];
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
- (void)photo{
    
    //UIScreen mainScreen是获取屏幕的实例（全屏显示）
    _zoomIV = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //激活用户交互功能
    _zoomIV.userInteractionEnabled = YES;
    _zoomIV.backgroundColor = [UIColor blackColor];
    
    _zoomIV.image=_image2.image;
    
    _zoomIV.contentMode = UIViewContentModeScaleAspectFit;
    //[UIApplication sharedApplication]获得当前App的实例，keyWindow方法可以拿到App实例的主窗口
    [[UIApplication sharedApplication].keyWindow addSubview:_zoomIV];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomTap:)];
    [_zoomIV addGestureRecognizer:tap];
    
    
    
    
    
}
- (void)zoomTap:(UITapGestureRecognizer *)sender{
    NSLog(@"要缩小");
    if (sender.state == UIGestureRecognizerStateRecognized) {
        [_zoomIV removeFromSuperview];
        [_zoomIV removeGestureRecognizer:sender];
        _zoomIV = nil;
    }
    
}


@end
