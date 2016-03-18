//
//  JViewController.m
//  JGestureUnlockDemo
//
//  Created by ZhangJie on 3/19/16.
//  Copyright © 2016 zhangjie520. All rights reserved.
//

#import "JViewController.h"
#import "ViewController.h"

@interface JViewController()

@property (weak, nonatomic) IBOutlet UISwitch *mySwitch;


@end

@implementation JViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.mySwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"unlock"];

}

- (IBAction)changeValue:(id)sender {
    UISwitch *s = sender;
    if (s.on) {
        ViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ViewController"];
        vc.lockType = LOCK_TYPE_DRAW;
        [self presentViewController:vc animated:YES completion:nil];
        
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"unlock"];
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"password"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
