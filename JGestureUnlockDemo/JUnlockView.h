//
//  JUnlockView.h
//  JGestureUnlockDemo
//
//  Created by ZhangJie on 3/18/16.
//  Copyright © 2016 zhangjie520. All rights reserved.
//
#import <UIKit/UIKit.h>

@class JUnlockView;
@protocol JUnlockViewDelegate <NSObject>

@optional
- (BOOL)didDrawLockView:(JUnlockView *)lockView password:(NSString *)password;

@end




@interface JUnlockView : UIView

@property (nonatomic, weak) id<JUnlockViewDelegate> delegate;
@end
