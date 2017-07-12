//
//  CustomTabBar.m
//  freeemansec
//
//  Created by adamwu on 2017/6/30.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "CustomTabBar.h"

@interface CustomTabBar ()
// 中间按钮
@property (nonatomic, strong) UIButton *centerBtn;
@end

@implementation CustomTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 加载子视图
        [self setUpChildrenViews];
    }
    return self;
}

// 创建子视图
- (void)setUpChildrenViews {
    
    self.backgroundColor = [UIColor whiteColor];
    
    //去掉TabBar的分割线
    [self setBackgroundImage:[UIImage new]];
    [self setShadowImage:[UIImage new]];
    self.centerBtn = [[UIButton alloc] init];
    [_centerBtn setBackgroundImage:[UIImage imageNamed:@"tab_launch"] forState:UIControlStateNormal];
    [_centerBtn setBackgroundImage:[UIImage imageNamed:@"tab_launch"] forState:UIControlStateHighlighted];
    // 按钮和当前背景图片一样大
    _centerBtn.size = _centerBtn.currentBackgroundImage.size;
    [_centerBtn addTarget:self action:@selector(centerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_centerBtn];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 重新排布系统按钮位置,空出中间按钮位置,系统按钮类型是UITabBarButton
    Class class = NSClassFromString(@"UITabBarButton");
    
    self.centerBtn.centerX = self.centerX;
    //调整中间按钮的中线点Y值
    self.centerBtn.centerY = self.height - self.centerBtn.height*0.5;
    
    NSInteger btnIndex = 0;
    for (UIView *btn in self.subviews) {
        //遍历系统tabbar的子控件
        if ([btn isKindOfClass:class]) {
            //如果是系统的UITabBarButton，那么就调整子控件位置，空出中间位置
            //按钮宽度为TabBar宽度减去中间按钮宽度的1/4
            btn.width = (self.width - self.centerBtn.width)/4;
            //中间按钮前的宽度,这里就3个按钮，中间按钮Index为1
            if (btnIndex < 2) {
                btn.x = btn.width * btnIndex;
            } else { //中间按钮后的宽度
                btn.x = btn.width * btnIndex + self.centerBtn.width;
            }
            
            btnIndex++;
            //如果是索引是0(从0开始的)，直接让索引++，目的就是让消息按钮的位置向右移动，空出来中间按钮的位置
            if (btnIndex == 0) {
                btnIndex++;
            }
        }
    }
    
    [self bringSubviewToFront:self.centerBtn];
}

#pragma mark - 中间按钮点击事件
- (void)centerBtnAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabBarCenterAction" object:self userInfo:nil];
}

//重写hitTest方法，去监听中间按钮的点击，目的是为了让凸出的部分点击也有反应
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    //判断当前手指是否点击到中间按钮上，如果是，则响应按钮点击，其他则系统处理
    //首先判断当前View是否被隐藏了，隐藏了就不需要处理了
    if (self.isHidden == NO) {
        
        //将当前tabbar的触摸点转换坐标系，转换到中间按钮的身上，生成一个新的点
        CGPoint newP = [self convertPoint:point toView:self.centerBtn];
        
        //判断如果这个新的点是在中间按钮身上，那么处理点击事件最合适的view就是中间按钮
        if ( [self.centerBtn pointInside:newP withEvent:event]) {
            return self.centerBtn;
            
        }
    }
    
    return [super hitTest:point withEvent:event];
}
@end
