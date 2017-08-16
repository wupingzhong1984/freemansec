//
//  LiveSearchQuickChoiceView.m
//  freemansec
//
//  Created by adamwu on 2017/8/11.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "LiveSearchQuickChoiceView.h"
#import "HotSearchWordsView.h"

@interface LiveSearchQuickChoiceView ()
<HotSearchWordsViewDelegate,
UIScrollViewDelegate>

@end

@implementation LiveSearchQuickChoiceView

- (id)initWithHeight:(CGFloat)height hotwords:(NSMutableArray*)hotwords history:(NSMutableArray*)history{
    
    if (self = [super initWithFrame:CGRectZero]) {
        
        self.size = CGSizeMake(K_UIScreenWidth, height);
        self.backgroundColor = [UIColor whiteColor];
        
        UIScrollView *contentView = [[UIScrollView alloc] init];
        contentView.size = self.size;
        contentView.delegate = self;
        [self addSubview:contentView];
        
        CGFloat originY = 24;
        if (hotwords && hotwords.count > 0) {
            
            UIView *blue = [[UIView alloc] initWithFrame:CGRectMake(0, originY, 3, 18)];
            blue.backgroundColor = UIColor_82b432;
            [contentView addSubview:blue];
            
            //NSLocalizedString
            UILabel *lbl = [UILabel  createLabelWithFrame:CGRectZero text:@"热门搜索" textColor:[UIColor darkGrayColor] font:[UIFont systemFontOfSize:16]];
            [lbl sizeToFit];
            lbl.x = 10;
            lbl.centerY = blue.centerY;
            [contentView addSubview:lbl];
            
            HotSearchWordsView *v = [[HotSearchWordsView alloc] initWithStrs:hotwords width:(contentView.width - 20)];
            v.origin = CGPointMake(10, 60);
            v.delegate = self;
            [contentView addSubview:v];
            
            originY = v.maxY + 24;
        }
        
        if (history && history.count > 0) {
            
            UIView *blue = [[UIView alloc] initWithFrame:CGRectMake(0, originY, 3, 18)];
            blue.backgroundColor = UIColor_82b432;
            [contentView addSubview:blue];
            
            //NSLocalizedString
            UILabel *lbl = [UILabel  createLabelWithFrame:CGRectZero text:@"历史搜索" textColor:[UIColor darkGrayColor] font:[UIFont systemFontOfSize:16]];
            [lbl sizeToFit];
            lbl.x = 10;
            lbl.centerY = blue.centerY;
            [contentView addSubview:lbl];
            
            UILabel *title;
            UIView *line;
            UIButton *btn;
            for (int i = 0; i < history.count; i++) {
                
                title = [UILabel createLabelWithFrame:CGRectZero text:[history objectAtIndex:i] textColor:[UIColor grayColor] font:[UIFont systemFontOfSize:16]];
                [title sizeToFit];
                title.x = 10;
                title.centerY = blue.maxY + 20 + 40*i;
                [contentView addSubview:title];
                
                line = [[UIView alloc] initWithFrame:CGRectMake(0, title.centerY + 15-0.5, self.width, 0.5)];
                line.backgroundColor = UIColor_line_d2d2d2;
                [contentView addSubview:line];
                
                btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = 2000+i;
                btn.frame = CGRectMake(0, line.maxY - 40, self.width, 40);
                [btn addTarget:self action:@selector(searchHistorySelected:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            contentView.contentSize = CGSizeMake(contentView.width, line.maxY);
        }
    }
    
    return self;
}

- (void)searchHistorySelected:(UIButton*)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(LiveSearchQuickChoiceViewDelegateSearchWord:)]) {
        
        [_delegate LiveSearchQuickChoiceViewDelegateSearchWord:[[LiveManager getLiveSearchHistory] objectAtIndex:(sender.tag - 2000)]];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (_delegate && [_delegate respondsToSelector:@selector(LiveSearchQuickChoiceViewDelegateDidScroll)]) {
        
        [_delegate LiveSearchQuickChoiceViewDelegateDidScroll];
    }
}

- (void)HotSearchWordsViewDelegateSelectedWord:(NSString *)word {
    
    if (_delegate && [_delegate respondsToSelector:@selector(LiveSearchQuickChoiceViewDelegateSearchWord:)]) {
        
        [_delegate LiveSearchQuickChoiceViewDelegateSearchWord:word];
    }
}
@end
