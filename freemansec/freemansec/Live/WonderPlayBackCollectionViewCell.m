//
//  WonderPlayBackCollectionViewCell.m
//  freemansec
//
//  Created by adamwu on 2017/9/1.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "WonderPlayBackCollectionViewCell.h"
#import "LivePlayBackModel.h"

@interface WonderPlayBackCollectionViewCell ()
@property (nonatomic,strong) UIImageView *face;
@property (nonatomic,strong) UILabel *count;
@property (nonatomic,strong) UIImageView *icon;
@property (nonatomic,strong) UILabel *title;
@end

@implementation WonderPlayBackCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        
        self.face = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, (int)self.width*3/4)];
        [self addSubview:_face];
        
        self.title = [[UILabel alloc] init];
        _title.font = [UIFont systemFontOfSize:12];
        _title.textColor = [UIColor darkGrayColor];
        _title.x = 5;
        _title.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:_title];
        
        self.count = [[UILabel alloc] init];
        _count.font = [UIFont systemFontOfSize:12];
        _count.textColor = UIColor_line_d2d2d2;
        [self addSubview:_count];
        
        self.icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"playback_playcount_icon.png"]];
        [self addSubview:_icon];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)setPlayBackModel:(LivePlayBackModel *)playBackModel {
    
    if (playBackModel) {
        
        [_face sd_setImageWithURL:[NSURL URLWithString:playBackModel.liveImg] placeholderImage:[UIImage imageNamed:@"cover_place.png"]];
        
        
        _count.text = playBackModel.playCount;
        [_count sizeToFit];
        _count.centerY = _face.maxY + 30/2;
        _count.x = _face.width - _count.width - 5;
        
        _icon.centerY = _count.centerY;
        _icon.x = _count.x - 5 - _icon.width;
        
        _title.text = playBackModel.title;
        [_title sizeToFit];
        _title.centerY = _count.centerY;
        _title.x = 5;
        _title.width = _icon.x - 5 - _title.x;
        
    }
}

- (void)setSelected:(BOOL)selected {
    
    
}

@end
