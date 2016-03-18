//
//  ViewController.h
//  JGestureUnlockDemo
//
//  Created by ZhangJie on 3/18/16.
//  Copyright © 2016 zhangjie520. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,LockType){
    LOCK_TYPE_DRAW = 0,
    LOCK_TYPE_UNLOCK = 1
};

@interface ViewController : UIViewController

@property (nonatomic, assign) LockType lockType;
@end

