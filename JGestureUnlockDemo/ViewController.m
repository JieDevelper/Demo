//
//  ViewController.m
//  JGestureUnlockDemo
//
//  Created by ZhangJie on 3/18/16.
//  Copyright © 2016 zhangjie520. All rights reserved.
//

#import "ViewController.h"
#import "JUnlockView.h"

@interface ViewController ()<JUnlockViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *warnLabel;

@property (weak, nonatomic) IBOutlet JUnlockView *lockView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lockView.delegate = self;
    self.lockType = LOCK_TYPE_UNLOCK;
    if (self.lockType == LOCK_TYPE_DRAW) {
        self.warnLabel.text = @"请绘制手势！";
        [self addButton];
    }else{
        self.warnLabel.text = @"";
    }
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)addButton {
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 40, 100, 40)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.enabled = YES;
    [saveBtn addTarget:self action:@selector(savePassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-100, 40, 100, 40)];
    [cancelBtn addTarget:self action:@selector(dissMiss) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.view addSubview:cancelBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)didDrawLockView:(JUnlockView *)lockView password:(NSString *)password {
    if ([password isEqualToString:@"0125"]) {
        self.warnLabel.text = @"密码正确!";
        return YES;
    }
    
    self.warnLabel.text = @"密码错误,你还有5次机会";
    [self labelJiggle];
    return NO;
}


// TODO:
- (void)savePassword {
    NSLog(@"asdf");
    [self labelJiggle];
    
}

- (void)labelJiggle {
    CGRect orgRect = self.warnLabel.frame;
    [UIView animateWithDuration:0.05 animations:^{
        self.warnLabel.frame = CGRectOffset(orgRect, -10, 0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.05 animations:^{
            self.warnLabel.frame = CGRectOffset(orgRect, 10, 0);
        } completion:^(BOOL finished) {
            self.warnLabel.frame = orgRect;
        }];
    }];
}

- (void)dissMiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
