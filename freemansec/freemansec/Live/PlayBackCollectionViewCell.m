//
//  PlayBackCollectionViewCell.m
//  freemansec
//
//  Created by adamwu on 2017/9/1.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "PlayBackCollectionViewCell.h"

@interface PlayBackCollectionViewCell ()
@property (nonatomic,strong) UIImageView *face;
@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) UILabel *time;
@end

@implementation PlayBackCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        
        self.face = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, (int)self.width*3/4)];
        [self addSubview:_face];
        
        UIView *cover = [[UIView alloc] initWithFrame:_face.frame];
        cover.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f];
        [self addSubview:cover];
        
        UIImageView *play = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"playback_cover_icon.png"]];
        play.center = cover.center;
        [self addSubview:play];
        
        self.title = [[UILabel alloc] init];
        _title.font = [UIFont systemFontOfSize:14];
        _title.textColor = [UIColor darkGrayColor];
        _title.x = 8;
        _title.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:_title];
        
        self.time = [[UILabel alloc] init];
        _time.font = [UIFont systemFontOfSize:14];
        _time.textColor = UIColor_line_d2d2d2;
        _time.x = 8;
        _time.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:_time];
        
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = UIColor_line_d2d2d2.CGColor;
    }
    
    return self;
}

- (void)setPlayBackModel:(LivePlayBackModel *)playBackModel {
    
    if (playBackModel) {
        
        [_face sd_setImageWithURL:[NSURL URLWithString:playBackModel.liveImg] placeholderImage:[UIImage imageNamed:@"cover_place.png"]];
        
        _title.text = playBackModel.title;
        [_title sizeToFit];
        _title.centerY = _face.maxY + 20/2;
        _title.width = _face.width - _title.x*2;
        
        _time.text = playBackModel.createTime;
        [_time sizeToFit];
        _time.centerY = _face.maxY + 20 + 20/2 - 3;
        _time.width = _title.width;
        
    }
}

- (void)setSelected:(BOOL)selected {
    
    
}

@end
