//
//  ActivityViewController.h
//  TRUMate
//
//  email：chongyangfly@163.com
//  QQ：1909295866
//  github：https://github.com/wangcy90
//  blog：http://wangcy90.github.io
//
//  Created by WangChongyang on 2016/10/11.
//  Copyright © 2016年 WangChongyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityAction : NSObject

+ (instancetype)actionWithTitle:(NSString *)title imageName:(NSString *)imageName handler:(void (^)(ActivityAction *action))handler;

@property (nonatomic, copy, readonly) NSString *title;

@property (nonatomic, copy, readonly) NSString *imageName;

@end

@interface ActivityViewController : UIViewController

@property(nonatomic, copy)NSString *cancelButtonTitle;

+ (instancetype)activityControllerWithTitle:(NSString *)title description:(NSString *)description;

- (void)addAction:(ActivityAction *)action;

@end
