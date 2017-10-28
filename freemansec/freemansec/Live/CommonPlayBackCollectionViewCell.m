//
//  CommonPlayBackCollectionViewCell.m
//  freemansec
//
//  Created by adamwu on 2017/10/29.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "CommonPlayBackCollectionViewCell.h"

@interface CommonPlayBackCollectionViewCell ()
@property (nonatomic,strong) UIImageView *coverIV;
@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) UILabel *addTime;
@property (nonatomic,strong) UIImageView *playCountIcon;
@property (nonatomic,strong) UILabel *playCountLbl;
@end

@implementation CommonPlayBackCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        
        self.coverIV = [[UIImageView alloc] init];
        _coverIV.size = CGSizeMake(self.width, self.width);
        _coverIV.contentMode = UIViewContentModeScaleAspectFill;
        _coverIV.clipsToBounds = YES;
        [self addSubview:_coverIV];
        
        self.title = [[UILabel alloc] init];
        _title.font = [UIFont systemFontOfSize:14];
        _title.textAlignment = NSTextAlignmentLeft;
        _title.lineBreakMode = NSLineBreakByTruncatingTail;
        _title.textColor = [UIColor blackColor];
        [self addSubview:_title];
        
        self.addTime = [[UILabel alloc] init];
        _addTime.font = [UIFont systemFontOfSize:14];
        _addTime.textAlignment = NSTextAlignmentLeft;
        _addTime.lineBreakMode = NSLineBreakByTruncatingTail;
        _addTime.textColor = [UIColor lightGrayColor];
        [self addSubview:_addTime];
        
        self.playCountIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"play_count_gray.png"]];
        [self addSubview:_playCountIcon];
        
        self.playCountLbl = [[UILabel alloc] init];
        _playCountLbl.font = [UIFont systemFontOfSize:12];
        _playCountLbl.textColor = [UIColor lightGrayColor];
        [self addSubview:_playCountLbl];
        
    }
    
    return self;
}

- (void)setVideoModel:(CommonVideoModel *)videoModel {
    
    if (videoModel) {
        
        
        [self.coverIV sd_setImageWithURL:[NSURL URLWithString:videoModel.headImg] placeholderImage:[UIImage imageNamed:@"cover_place_2.png"]];
        
        _title.text = videoModel.nickName;
        [_title sizeToFit];
        _title.x = 10;
        _title.centerY = 50/2 + _coverIV.maxY - 9;
        _title.width = _coverIV.maxX - _title.x*2;
        
        _addTime.text = videoModel.addTime;
        [_addTime sizeToFit];
        _addTime.x = 10;
        _addTime.centerY = 50/2 + _coverIV.maxY + 9;
        
        _playCountLbl.text = videoModel.playCount;
        [_playCountLbl sizeToFit];
        _playCountLbl.centerY = _addTime.centerY;
        
        _playCountLbl.x = self.width - 10 - _playCountLbl.width;
        _playCountIcon.centerY = _playCountLbl.centerY;
        _playCountIcon.x = _playCountLbl.x - 5 - _playCountIcon.width;
        _addTime.width = _playCountIcon.x - 5 - _addTime.x;
    }
}
@end
