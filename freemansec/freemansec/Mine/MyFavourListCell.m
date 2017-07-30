//
//  MyFavourListCell.m
//  freemansec
//
//  Created by adamwu on 2017/7/31.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "MyFavourListCell.h"

@interface MyFavourListCell ()
@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UILabel *titleLbl;
@property (nonatomic,strong) UILabel *anchorLbl;
@property (nonatomic,strong) UILabel *countLbl;
@end

@implementation MyFavourListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *cellBg = [[UIView alloc]
                          initWithFrame:CGRectMake(10,
                                                   10,
                                                   K_UIScreenWidth-20,
                                                   110)];
        cellBg.backgroundColor = [UIColor whiteColor];
        cellBg.clipsToBounds = YES;
        cellBg.layer.borderWidth = 0.5;
        cellBg.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self.contentView addSubview:cellBg];
        
        self.imgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 120, 90)];
        [self.contentView addSubview:_imgV];
        
        //NSLocalizedString
        UILabel *count = [UILabel createLabelWithFrame:CGRectZero text:@"播放数：" textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:13]];
        [count sizeToFit];
        count.x = _imgV.maxX + 10;
        count.y = _imgV.maxY - count.height;
        [self.contentView addSubview:count];
        
        self.countLbl = [[UILabel alloc] init];
        _countLbl.textColor = [UIColor blackColor];
        _countLbl.font = count.font;
        _countLbl.x = count.maxX+2;
        _countLbl.y = count.y;
        _countLbl.height = count.height;
        _countLbl.width = cellBg.maxX - 10 - _countLbl.x;
        [self.contentView addSubview:_countLbl];
        
        self.anchorLbl = [[UILabel alloc] init];
        _anchorLbl.textColor = [UIColor lightGrayColor];
        _anchorLbl.font = [UIFont systemFontOfSize:13];
        _anchorLbl.x = _imgV.maxX + 10;
        _anchorLbl.y = count.y - 10 - count.height;
        _anchorLbl.height = count.height;
        _anchorLbl.width = cellBg.maxX - 10 - _anchorLbl.x;
        [self.contentView addSubview:_anchorLbl];
        
        self.titleLbl = [[UILabel alloc] init];
        _titleLbl.textColor = [UIColor blackColor];
        _titleLbl.font = [UIFont systemFontOfSize:16];
        _titleLbl.x = count.x;
        _titleLbl.y = _imgV.y;
        _titleLbl.text = @"1";
        [_titleLbl sizeToFit];
        _titleLbl.width = cellBg.maxX - 10 - _titleLbl.x;
        [self.contentView addSubview:_titleLbl];
    }
    return self;
}

- (void)setFavourModel:(MyFavourModel *)favourModel {
    
    if (favourModel) {
        
        _favourModel = favourModel;
        
        [_imgV setImageWithURL:[NSURL URLWithString:_favourModel.img]];
        
        _titleLbl.text = _favourModel.title;
        _anchorLbl.text = _favourModel.anchorName;
        _countLbl.text = _favourModel.playCount;
    }
}

@end
