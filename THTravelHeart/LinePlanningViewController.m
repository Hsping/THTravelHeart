//
//  LinePlanningViewController.m
//  THTravelHeart
//
//  Created by Hsping on 16/4/23.
//  Copyright © 2016年 TianHan. All rights reserved.
//

#import "LinePlanningViewController.h"

@interface LinePlanningViewController ()

@end

@implementation LinePlanningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
