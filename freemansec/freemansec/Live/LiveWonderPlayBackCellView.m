//
//  LiveWonderPlayBackCellView.m
//  freemansec
//
//  Created by adamwu on 2017/9/1.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "LiveWonderPlayBackCellView.h"

@implementation LiveWonderPlayBackCellView

- (id)initWithPlayBack:(LivePlayBackModel*)playBack width:(CGFloat)width {
    
    if (self = [super initWithFrame:CGRectZero]) {
        
        self.width = width;
        
        UIImageView *face = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, (int)self.width*3/4)];
        [self addSubview:face];
        [face sd_setImageWithURL:[NSURL URLWithString:playBack.liveImg] placeholderImage:[UIImage imageNamed:@"cover_place.png"]];
        
        UIView *cover = [[UIView alloc] initWithFrame:face.frame];
        cover.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f];
        [self addSubview:cover];
        
        UIImageView *play = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"playback_cover_icon.png"]];
        play.center = cover.center;
        [self addSubview:play];
        
        UILabel *count = [UILabel createLabelWithFrame:CGRectZero text:playBack.playCount textColor:UIColor_line_d2d2d2 font:[UIFont systemFontOfSize:12]];
        [count sizeToFit];
        count.centerY = face.maxY + 30/2;
        count.x = self.width - count.width;
        [self addSubview:count];
        
        
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"playback_playcount_icon.png"]];
        icon.centerY = count.centerY;
        icon.x = count.x - 5 - icon.width;
        [self addSubview:icon];
        
        UILabel *title = [UILabel createLabelWithFrame:CGRectZero text:playBack.title textColor:[UIColor darkGrayColor] font:[UIFont systemFontOfSize:12]];
        [title sizeToFit];
        title.centerY = count.centerY;
        title.x = 0;
        title.lineBreakMode = NSLineBreakByTruncatingTail;
        title.width = icon.x - 5 - title.x;
        [self addSubview:title];
        
        self.height = face.maxY + 30;
        
    }
    
    return self;
}

@end
