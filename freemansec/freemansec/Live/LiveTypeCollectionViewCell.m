//
//  LiveTypeCollectionViewCell.m
//  freemansec
//
//  Created by adamwu on 2017/10/28.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "LiveTypeCollectionViewCell.h"

@interface LiveTypeCollectionViewCell ()
@property (nonatomic,strong) UIImageView *face;
@property (nonatomic,strong) UILabel *title;
@end

@implementation LiveTypeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        
        self.face = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, (int)self.width*3/4)];
        _face.clipsToBounds = YES;
        _face.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_face];
        
        UIView *cover = [[UIView alloc] initWithFrame:_face.frame];
        cover.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f];
        [self addSubview:cover];
        
        UIImageView *play = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"playback_cover_icon.png"]];
        play.center = cover.center;
        [self addSubview:play];
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, _face.maxY, _face.width, 40)];
        _title.font = [UIFont systemFontOfSize:17];
        _title.textColor = [UIColor darkGrayColor];
        _title.lineBreakMode = NSLineBreakByTruncatingTail;
        _title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_title];
        
        
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = UIColor_line_d2d2d2.CGColor;
    }
    
    return self;
}

- (void)setTypeModel:(OfficialLiveTypeModel *)typeModel {
    
    if (typeModel) {
        
        [_face sd_setImageWithURL:[NSURL URLWithString:typeModel.liveTypeImg] placeholderImage:[UIImage imageNamed:@"cover_place.png"]];
        
        _title.text = typeModel.liveTypeName;
        
    }
}

- (void)setSelected:(BOOL)selected {
    
    
}

@end
