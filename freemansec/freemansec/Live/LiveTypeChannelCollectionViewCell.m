//
//  LiveTypeChannelCollectionViewCell.m
//  freemansec
//
//  Created by adamwu on 2017/7/14.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "LiveTypeChannelCollectionViewCell.h"

@interface LiveTypeChannelCollectionViewCell ()

@property (nonatomic,strong) UIImageView *coverIV;
@property (nonatomic,strong) UILabel *title;

@end

@implementation LiveTypeChannelCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.coverIV = [[UIImageView alloc] init];
        _coverIV.size = CGSizeMake(self.width, self.width*3/4);
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

- (void)setChannelModel:(LiveChannelModel *)channelModel {
    
    if (channelModel) {
        
    [self.coverIV setImageWithURL:[NSURL URLWithString:channelModel.liveImg]
                 placeholderImage:[UIImage imageNamed:@"livetypechannel_cover_default.png"]];
        _title.text = channelModel.liveName;
        [_title sizeToFit];
        _title.width = _coverIV.width;
        _title.x = _coverIV.x;
        _title.y = _coverIV.maxY + 5;
    }
}

@end
