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
@property (nonatomic,strong) UILabel *archor;
@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) UIView *living;

@end

@implementation LiveSearchResultCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        
        self.coverIV = [[UIImageView alloc] init];
        _coverIV.size = CGSizeMake(self.width*4/3, self.width);
        _coverIV.x = (self.width - _coverIV.width)/2;
        [self addSubview:_coverIV];
        
        self.headIV = [[UIImageView alloc] init];
        _headIV.size = CGSizeMake(35, 35);
        _headIV.clipsToBounds = YES;
        _headIV.layer.cornerRadius = _headIV.width/2;
        [self addSubview:_headIV];
        
        self.archor = [[UILabel alloc] init];
        _archor.font = [UIFont systemFontOfSize:14];
        _archor.textAlignment = NSTextAlignmentLeft;
        _archor.lineBreakMode = NSLineBreakByTruncatingTail;
        _archor.textColor = [UIColor blackColor];
        [self addSubview:_archor];
        
        self.title = [[UILabel alloc] init];
        _title.font = [UIFont systemFontOfSize:14];
        _title.textAlignment = NSTextAlignmentLeft;
        _title.lineBreakMode = NSLineBreakByTruncatingTail;
        _title.textColor = [UIColor lightGrayColor];
        [self addSubview:_title];
        
        UIView *green = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
        green.layer.cornerRadius = 3;
        green.backgroundColor = [UIColor greenColor];
        
        UILabel *l = [UILabel createLabelWithFrame:CGRectZero text:@"直播中" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:13]];
        [l sizeToFit];
        
        self.living = [[UIView alloc] init];
        _living.size = CGSizeMake(green.width + l.width + 18, 20);
        _living.y = _coverIV.y + 7;
        _living.x = self.width - 7 - _living.width;
        _living.layer.cornerRadius = _living.height/2;
        _living.layer.borderColor = [UIColor whiteColor].CGColor;
        _living.layer.borderWidth = 0.5;
        _living.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        [self addSubview:_living];
        
        green.centerY = _living.height/2;
        green.x = 6;
        [_living addSubview:green];
        
        l.x = green.maxX + 6;
        l.centerY = green.centerY;
        [_living addSubview:l];
        
    }
    
    return self;
}

- (void)setResultModel:(LiveSearchResultModel *)resultModel {
    
    if (resultModel) {
        
        [self.coverIV sd_setImageWithURL:[NSURL URLWithString:resultModel.liveImg]];
        [self.headIV sd_setImageWithURL:[NSURL URLWithString:resultModel.headImg]];
        _headIV.x = 5;
        _headIV.centerY = 50/2 + _coverIV.maxY;
        _headIV.hidden = YES;
        
        _archor.text = resultModel.nickName;
        [_archor sizeToFit];
        _archor.x = 10;
        _archor.centerY = _headIV.centerY - 9;
        _archor.width = _coverIV.maxX - _archor.x*2;
        
        _title.text = resultModel.liveName;
        [_title sizeToFit];
        _title.x = 10;
        _title.centerY = _headIV.centerY + 9;
        _title.width = _archor.width;
        
        _living.hidden = !([resultModel.state isEqualToString:@"1"] || [resultModel.state isEqualToString:@"3"]);
    }
}

- (void)setSelected:(BOOL)selected {
    
    
}
@end
