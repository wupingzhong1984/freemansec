//
//  LiveBannerCollectionViewCell.m
//  freemansec
//
//  Created by adamwu on 2017/7/19.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "LiveBannerCollectionViewCell.h"

@interface LiveBannerCollectionViewCell ()

@property (nonatomic,strong) UIImageView *coverIV;

@end

@implementation LiveBannerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.coverIV = [[UIImageView alloc] init];
        _coverIV.size = self.size;
        [self addSubview:_coverIV];
    }
    
    return self;
}

- (void)setChannelModel:(LiveChannelModel *)channelModel {
    
    if (channelModel) {
        
        [self.coverIV sd_setImageWithURL:[NSURL URLWithString:channelModel.liveImg] placeholderImage:[UIImage imageNamed:@"cover_place.png"]];
    }
}

- (void)setSelected:(BOOL)selected {
    
    
}
@end
