//
//  ViewController.m
//  ActivityViewController
//
//  email：chongyangfly@163.com
//  QQ：1909295866
//  github：https://github.com/wangcy90
//  blog：http://wangcy90.github.io
//
//  Created by WangChongyang on 2017/7/11.
//  Copyright © 2017年 WangChongyang. All rights reserved.
//

#import "ViewController.h"
#import "ActivityViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClick:(id)sender {
    
    ActivityViewController *activityController = [ActivityViewController activityControllerWithTitle:@"分享到" description:@"请选择要分享的平台"];
    
    activityController.cancelButtonTitle = @"取消";
    
    ActivityAction *weChatAction = [ActivityAction actionWithTitle:@"微信好友" imageName:@"wechat" handler:^(ActivityAction *action) {
        [self showAlertWithMessage:@"点击了：微信好友"];
    }];
    
    ActivityAction *qqAction = [ActivityAction actionWithTitle:@"朋友圈" imageName:@"moments" handler:^(ActivityAction *action) {
        [self showAlertWithMessage:@"点击了：朋友圈"];
    }];
    
    ActivityAction *dropboxAction = [ActivityAction actionWithTitle:@"Dropbox" imageName:@"dropbox" handler:^(ActivityAction *action) {
        [self showAlertWithMessage:@"点击了：Dropbox"];
    }];
    
    ActivityAction *baiduAction = [ActivityAction actionWithTitle:@"Baidu" imageName:@"baidu" handler:^(ActivityAction *action) {
        [self showAlertWithMessage:@"点击了：Baidu"];
    }];
    
    [activityController addAction:weChatAction];
    
    [activityController addAction:qqAction];
    
    [activityController addAction:dropboxAction];
    
    [activityController addAction:baiduAction];
    
    [self presentViewController:activityController animated:YES completion:NULL];
    
}

- (void)showAlertWithMessage:(NSString *)message {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:NULL];
    
    [alert addAction:confirmAction];
    
    [self presentViewController:alert animated:YES completion:NULL];
    
}

@end
