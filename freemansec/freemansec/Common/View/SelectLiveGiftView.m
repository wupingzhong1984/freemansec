//
//  SelectLiveGiftView.m
//  freemansec
//
//  Created by adamwu on 2017/11/27.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "SelectLiveGiftView.h"
#import "LiveGiftModel.h"
#import "LiveGiftView.h"

@interface SelectLiveGiftView ()
@property (nonatomic,assign) NSInteger selectedIndex;
@end

@implementation SelectLiveGiftView

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.frame = CGRectMake(0, 0, K_UIScreenWidth, K_UIScreenHeight);
        
        UIButton *bgTouch = [UIButton buttonWithType:UIButtonTypeCustom];
        bgTouch.size = self.size;
        [bgTouch addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgTouch];
        
        UIView *darkBg = [[UIView alloc] init];
        darkBg.width = self.width;
        darkBg.backgroundColor = [UIColor darkGrayColor];
        [self addSubview:darkBg];
        
        NSMutableArray *giftArray = [[UserLiveManager sharedInstance] getNewestGiftArray];
        CGSize itemSize = [UIImage imageNamed:@"gift_selected_0.png"].size;
        CGFloat space = (darkBg.width - itemSize.width*4)/5;
        CGFloat originX = space;
        CGFloat originY = 10;
        LiveGiftView *v;
        for (int i = 0; i < giftArray.count; i++) {
            
            LiveGiftModel *gift = [giftArray objectAtIndex:i];
            
            v = [[LiveGiftView alloc] initWithFrame:CGRectMake(0, 0, itemSize.width, itemSize.height)];
            v.bgImgV.image = [UIImage imageNamed:(i == 0?@"gift_selected_1.png":@"gift_selected_0.png")];
            [v.touchBtn addTarget:self action:@selector(giftClicked:) forControlEvents:UIControlEventTouchUpInside];
            v.giftImgUrl = gift.giftImg;
            v.giftName = gift.giftName;
            v.coin = gift.coin;
            v.origin = CGPointMake(originX, originY);
            v.tag = 100+i;
            [darkBg addSubview:v];
            
            if ((i+1)%4 == 0) {
                originX = space;
                originY += 10 + itemSize.height;
            } else {
                originX += space + itemSize.width;
            }
        }
        
        UIButton *presentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [presentBtn addTarget:self action:@selector(presentAction) forControlEvents:UIControlEventTouchUpInside];
        presentBtn.frame = CGRectMake(space, v.maxY + 10, darkBg.width - space*2, 30);
        presentBtn.backgroundColor = [UIColor lightGrayColor];
        [presentBtn setTitle:NSLocalizedString(@"present", nil) forState:UIControlStateNormal];
        [presentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [darkBg addSubview:presentBtn];
        
        darkBg.height = presentBtn.maxY + 10;
        darkBg.y = self.height - darkBg.height;
    }
    
    return self;
}

- (void)cancel {
    
    [self removeFromSuperview];
}

- (void)giftClicked:(id)sender {
    
    LiveGiftView *v;
    UIButton *btn = (UIButton*)sender;
    v = (LiveGiftView*)[btn superview];
    
    if (v.tag - 100 == _selectedIndex) { //已选中
        return;
    }
    
    //old
    v = (LiveGiftView*)[self viewWithTag:(100+_selectedIndex)];
    v.bgImgV.image = [UIImage imageNamed:@"gift_selected_0.png"];
    
    //new
    v = (LiveGiftView*)[btn superview];
    v.bgImgV.image = [UIImage imageNamed:@"gift_selected_1.png"];
    _selectedIndex = v.tag - 100;
    
}

- (void)presentAction {
    
    if(_delegate && [_delegate respondsToSelector:@selector(presentGiftByIndex:)]) {
        
        [_delegate presentGiftByIndex:_selectedIndex];
        [self removeFromSuperview];
    }
}
@end
