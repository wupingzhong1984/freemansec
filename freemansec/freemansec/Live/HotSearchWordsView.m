//
//  HotSearchWordsView.m
//  freemansec
//
//  Created by adamwu on 2017/8/11.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "HotSearchWordsView.h"

@interface HotSearchWordsView ()

@property (nonatomic,strong) NSMutableArray *array;
@end

@implementation HotSearchWordsView

-(void)titBtnClike:(UIButton *)btn
{
    
    if (_delegate && [_delegate respondsToSelector:@selector(HotSearchWordsViewDelegateSelectedWord:)]) {
        
        [_delegate HotSearchWordsViewDelegateSelectedWord:_array[btn.tag-1000]];
    }
}

- (id)initWithStrs:(NSMutableArray *)strs width:(CGFloat)width{
    
    if (self = [super initWithFrame:CGRectMake(0, 0, width, 0)]) {
        
        self.array = [[NSMutableArray alloc] init];
        [_array addObjectsFromArray:strs];
        
        //间距
        CGFloat padding = 10;
        
        CGFloat titBtnX = 0;
        CGFloat titBtnY = 0;
        CGFloat titBtnH = 33;
        
        UIButton *titBtn;
        for (int i = 0; i < _array.count; i++) {
            titBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            //设置按钮的样式
            titBtn.layer.borderWidth = 1;
            titBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            [titBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            titBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            [titBtn setTitle:_array[i] forState:UIControlStateNormal];
            titBtn.tag = 1000+i;
            [titBtn addTarget:self action:@selector(titBtnClike:) forControlEvents:UIControlEventTouchUpInside];
            
            //计算文字大小
            CGSize titleSize = [_array[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, titBtnH) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:titBtn.titleLabel.font} context:nil].size;
            CGFloat titBtnW = titleSize.width + 2 * padding;
            //判断按钮是否超过屏幕的宽
            if ((titBtnX + titBtnW) > self.width) {
                titBtnX = 0;
                titBtnY += titBtnH + padding;
            }
            //设置按钮的位置
            titBtn.frame = CGRectMake(titBtnX, titBtnY, titBtnW, titBtnH);
            
            titBtnX += titBtnW + padding;
            
            [self addSubview:titBtn];
        }
        
        self.height = titBtn.maxY;
    }
    
    return self;
}

@end
