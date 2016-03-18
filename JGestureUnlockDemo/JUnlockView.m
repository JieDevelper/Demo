//
//  JUnlockView.m
//  JGestureUnlockDemo
//
//  Created by ZhangJie on 3/18/16.
//  Copyright © 2016 zhangjie520. All rights reserved.
//

#import "JUnlockView.h"

#define kLineColor [UIColor colorWithRed:0.0 green:170/255.0 blue:255/255.0 alpha:1.0]

@interface JUnlockView()

@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, strong) NSMutableArray *selectedButtons;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGPoint currentPoint;
@end

@implementation JUnlockView

- (UIColor *)lineColor {
    return _lineColor;
}

- (NSMutableArray *)selectedButtons {
    if (_selectedButtons == nil) {
        _selectedButtons = [NSMutableArray array];
    }
    return _selectedButtons;
}

- (NSArray *)buttons {
    if (_buttons == nil) {
        NSMutableArray *array = [NSMutableArray array];
        //创建9个按钮
        for (int i = 0; i<9; i++) {
            UIButton *btn = [[UIButton alloc] init];
            btn.tag = i;
            btn.userInteractionEnabled  = NO;
            [btn setImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
            [btn setImage:[UIImage imageNamed:@"gesture_node_error"] forState:UIControlStateDisabled];
            
            [array addObject:btn];
        }
        _buttons = array;
    }
    return _buttons;
}

- (void)awakeFromNib {
    _lineColor = kLineColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = 74;
    CGFloat height = 74;
    
    int row = 3, col = 3;
    CGFloat marginX = (self.frame.size.width - col*width) / (col + 1);
    CGFloat marginY = (self.frame.size.height - row*height)/ (row + 1);
    for (int i = 0; i<self.buttons.count; i++) {
        UIButton *btn = self.buttons[i];
        int rowNumber = i / row; // 行号。
        int colNumber = i % col; // 列号。
        
        CGFloat x = marginX + colNumber*(width + marginX);
        CGFloat y = marginY + rowNumber*(height + marginY);
        
        btn.frame = CGRectMake(x, y, width, height);
        [self addSubview:btn];
    }
}


- (void)drawRect:(CGRect)rect {
    if (self.selectedButtons == nil || self.selectedButtons.count == 0) {
        return;
    }
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    for (int i = 0; i<self.selectedButtons.count; i++) {
        UIButton *btn = self.selectedButtons[i];
        if (i == 0) {//第一个点。
            [path moveToPoint:btn.center];
        }else{
            [path addLineToPoint:btn.center];
        }
    }
    
    [path addLineToPoint:_currentPoint];
    
    [self.lineColor set];
    [path setLineWidth:4.0];
    
    [path stroke];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint p = [touch locationInView:touch.view];
    for (UIButton *btn in self.buttons) {
        if (CGRectContainsPoint(btn.frame, p) && !btn.selected) {
            btn.selected  = YES;
            [self.selectedButtons addObject:btn];
            break;
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint p = [touch locationInView:touch.view];
    for (UIButton *btn in self.buttons) {
        if (CGRectContainsPoint(btn.frame, p) && !btn.selected) {
            btn.selected  = YES;
            [self.selectedButtons addObject:btn];
            break;
        }
    }
    _currentPoint = p;
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSMutableString *password = [NSMutableString string];
    for (UIButton *btn in self.selectedButtons) {
        [password appendString:[NSString stringWithFormat:@"%@",@(btn.tag)]];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didDrawLockView:password:)]) {
        if (![self.delegate didDrawLockView:self password:password]) {
            //密码不正确
            self.lineColor = [UIColor redColor];
            for (UIButton *btn in self.selectedButtons) {
                btn.enabled = NO;
                btn.selected = NO;
            }
            
            [self setNeedsDisplay];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self resetBtn];
            });
            
        }else{
            [self resetBtn];
        }
    }else{
        [self resetBtn];
    }
    
    
}

- (void)resetBtn {
    for (UIButton *btn in self.buttons) {
        btn.selected = NO;
        btn.enabled = YES;
    }
    self.lineColor = kLineColor;
    [self.selectedButtons removeAllObjects];
    [self setNeedsDisplay];
}
@end
