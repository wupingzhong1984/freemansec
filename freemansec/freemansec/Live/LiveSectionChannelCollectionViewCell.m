//
//  LiveSectionChannelCollectionViewCell.m
//  freemansec
//
//  Created by adamwu on 2017/7/14.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "LiveSectionChannelCollectionViewCell.h"

@interface LiveSectionChannelCollectionViewCell ()

@property (nonatomic,strong) UIImageView *coverIV;
@property (nonatomic,strong) UILabel *title;

@end

@implementation LiveSectionChannelCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        UIImage *img = [UIImage imageNamed:@"livesectionchannel_cover_default.png"];
        
        self.coverIV = [[UIImageView alloc] init];
        _coverIV.size = CGSizeMake(self.width, self.width/(img.size.width/img.size.height));
        [self addSubview:_coverIV];
        
        self.title = [[UILabel alloc] init];
        _title.font = [UIFont systemFontOfSize:12];
        _title.textColor = [UIColor blackColor];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.lineBreakMode = NSLineBreakByTruncatingTail;
        _title.textColor = [UIColor blackColor];
        [self addSubview:_title];
    }
    
    return self;
}

- (void)setChannelModel:(LiveSectionChannelModel *)channelModel {
    
//    if (channelModel) {
        
        [_coverIV setImage:[UIImage imageNamed:@"livesectionchannel_cover_default.png"]];
        _title.text = @"小平的直播";
        [_title sizeToFit];
        _title.width = _coverIV.width;
        _title.x = _coverIV.x;
        _title.y = _coverIV.maxY + 5;
//    }
}

@end
