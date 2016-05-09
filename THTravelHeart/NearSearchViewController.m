//
//  NearSearchViewController.m
//  THTravelHeart
//
//  Created by Hsping on 16/4/23.
//  Copyright © 2016年 TianHan. All rights reserved.
//

#import "NearSearchViewController.h"
#import "SmallSpotsViewController.h"
#import "SDCycleScrollView.h"
@interface NearSearchViewController ()
@property(strong,nonatomic) NSString *i;
@end

@implementation NearSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
    _image3View.userInteractionEnabled=YES;
    
    UITapGestureRecognizer *photoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photo)];
    
    [self.image3View addGestureRecognizer:photoTap];
    
   
   
    _image4View.userInteractionEnabled=YES;
    UITapGestureRecognizer *photoTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photo1)];
    
    [self.image4View addGestureRecognizer:photoTap1];
    
    _image5View.userInteractionEnabled=YES;
    UITapGestureRecognizer *photoTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photo2)];
    
    [self.image5View addGestureRecognizer:photoTap2];

    _image6View.userInteractionEnabled=YES;
    UITapGestureRecognizer *photoTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photo3)];
    
    [self.image6View addGestureRecognizer:photoTap3];
    UIScrollView *demoContainerView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    demoContainerView.contentSize = CGSizeMake(self.view.frame.size.width, 1200);
    [_ViewA addSubview:demoContainerView];
    
    
    
    
    // 情景一：采用本地图片实现
    NSArray *imageNames = @[@"Image-3",
                            @"Image-4",
                            @"Image-8",
                            @"Image-9",
                            @"Image-10" // 本地图片请填写全名
                            ];
    
    // 本地加载 --- 创建不带标题的图片轮播器
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,-64, _ViewA.frame.size.width,_ViewA.frame.size.height+60) shouldInfiniteLoop:YES imageNamesGroup:imageNames];
    cycleScrollView.delegate = self;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    [demoContainerView addSubview:cycleScrollView];
}
#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    
    [self.navigationController pushViewController:[NSClassFromString(@"DemoVCWithXib") new] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)photo1{
    _i=@"1";
    [self photo];
}
-(void)photo2{
    _i = @"2";
    [self photo];
}

-(void)photo3{
    _i = @"3";
    [self photo];
}


- (void)photo{
    
    //UIScreen mainScreen是获取屏幕的实例（全屏显示）
    _zoomIV = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //激活用户交互功能
    _zoomIV.userInteractionEnabled = YES;
    _zoomIV.backgroundColor = [UIColor blackColor];
    if ([_i isEqualToString:@"1"]) {
        _zoomIV.image=_image4View.image;
        _i=nil;
    }else  if([_i isEqualToString:@"2"]){
        _zoomIV.image=_image5View.image;
        _i = nil;
    }else if([_i isEqualToString:@"3"]){
        _zoomIV.image = _image6View.image;
        _i = nil;
        
    }else {
        _zoomIV.image = _image3View.image;
        _i = nil;

    }
   
    
    _zoomIV.contentMode = UIViewContentModeScaleAspectFit;
    //[UIApplication sharedApplication]获得当前App的实例，keyWindow方法可以拿到App实例的主窗口
    [[UIApplication sharedApplication].keyWindow addSubview:_zoomIV];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomTap:)];
    [_zoomIV addGestureRecognizer:tap];
    
    
//    //UIScreen mainScreen是获取屏幕的实例（全屏显示）
//    _zoomIV1 = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    //激活用户交互功能
//    _zoomIV1.userInteractionEnabled = YES;
//    _zoomIV1.backgroundColor = [UIColor blackColor];
//    
//    _zoomIV1.image=_image4View.image;
//    
//    
//    _zoomIV1.contentMode = UIViewContentModeScaleAspectFit;
//    //[UIApplication sharedApplication]获得当前App的实例，keyWindow方法可以拿到App实例的主窗口
//    [[UIApplication sharedApplication].keyWindow addSubview:_zoomIV1];
//    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomTap:)];
//    [_zoomIV1 addGestureRecognizer:tap1];
    
    
}
- (void)zoomTap:(UITapGestureRecognizer *)sender{
    NSLog(@"缩小");
    if (sender.state == UIGestureRecognizerStateRecognized) {
        [_zoomIV removeFromSuperview];
        [_zoomIV removeGestureRecognizer:sender];
        _zoomIV = nil;
    }
    
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
