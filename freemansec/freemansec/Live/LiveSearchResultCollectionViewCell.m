//
//  LiveSearchResultCollectionViewCell.m
//  freemansec
//
//  Created by adamwu on 2017/8/13.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "LiveSearchResultCollectionViewCell.h"

@interface LiveSearchResultCollectionViewCell ()

@property (nonatomic,strong) UIImageView *coverIV;
@property (nonatomic,strong) UIImageView *headIV;
@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) UILabel *archor;

@end

@implementation LiveSearchResultCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.coverIV = [[UIImageView alloc] init];
        _coverIV.size = CGSizeMake(self.width, self.width*3/4);
        [self addSubview:_coverIV];
        
        self.headIV = [[UIImageView alloc] init];
        _headIV.size = CGSizeMake(35, 35);
        _headIV.clipsToBounds = YES;
        _headIV.layer.cornerRadius = _headIV.width/2;
        [self addSubview:_headIV];
        
        self.title = [[UILabel alloc] init];
        _title.font = [UIFont systemFontOfSize:12];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.lineBreakMode = NSLineBreakByTruncatingTail;
        _title.textColor = [UIColor blackColor];
        [self addSubview:_title];
        
        self.archor = [[UILabel alloc] init];
        _archor.font = [UIFont systemFontOfSize:11];
        _archor.textAlignment = NSTextAlignmentCenter;
        _archor.lineBreakMode = NSLineBreakByTruncatingTail;
        _archor.textColor = [UIColor lightGrayColor];
        [self addSubview:_archor];
    }
    
    return self;
}

- (void)setResultModel:(LiveSearchResultModel *)resultModel {
    
    if (resultModel) {
        
        [self.coverIV setImageWithURL:[NSURL URLWithString:resultModel.liveImg]];
        [self.headIV setImageWithURL:[NSURL URLWithString:resultModel.headImg]];
        _headIV.x = 5;
        _headIV.centerY = 45/2 + _coverIV.maxY;
        
        _title.text = resultModel.liveName;
        [_title sizeToFit];
        _title.x = _headIV.maxX + 5;
        if (resultModel.nickName.length > 0) {
            
            _title.centerY = _headIV.centerY - 7;
        } else {
            _title.centerY = _headIV.centerY;
        }
        _title.width = _coverIV.maxY - _title.x;
        
        _archor.text = resultModel.nickName;
        [_archor sizeToFit];
        _archor.x = _headIV.maxX + 5;
        _archor.centerY = _headIV.centerY + 7;
        _archor.width = _coverIV.maxY - _archor.x;
    }
}
@end
