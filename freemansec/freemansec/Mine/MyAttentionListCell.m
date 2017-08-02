//
//  MyAttentionListCell.m
//  freemansec
//
//  Created by adamwu on 2017/7/31.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "MyAttentionListCell.h"

@interface MyAttentionListCell ()
@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UILabel *titleLbl;
@property (nonatomic,strong) UILabel *typeLbl;
@property (nonatomic,strong) UILabel *anchorLbl;
@end

@implementation MyAttentionListCell

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
        self.anchorLbl = [UILabel createLabelWithFrame:CGRectZero text:@"1" textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:13]];
        [_anchorLbl sizeToFit];
        _anchorLbl.x = _imgV.maxX + 10;
        _anchorLbl.y = _imgV.maxY - _anchorLbl.height;
        _anchorLbl.width = cellBg.maxX - 10 - _anchorLbl.x;
        [self.contentView addSubview:_anchorLbl];
        
        self.typeLbl = [UILabel createLabelWithFrame:CGRectZero text:@"1" textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:13]];
        [_typeLbl sizeToFit];
        _typeLbl.x = _imgV.maxX + 10;
        _typeLbl.y = _anchorLbl.y - 10 - _typeLbl.height;
        _typeLbl.width = cellBg.maxX - 10 - _typeLbl.x;
        [self.contentView addSubview:_typeLbl];
        
        self.titleLbl = [UILabel createLabelWithFrame:CGRectZero text:@"1" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:16]];
        [_titleLbl sizeToFit];
        _titleLbl.x = _typeLbl.x;
        _titleLbl.y = _imgV.y;
        _titleLbl.width = cellBg.maxX - 10 - _titleLbl.x;
        [self.contentView addSubview:_titleLbl];
    }
    return self;
}

- (void)setAttentionModel:(MyAttentionModel *)attentionModel {
    
    if (attentionModel) {
        
        _attentionModel = attentionModel;
        
        [_imgV setImageWithURL:[NSURL URLWithString:_attentionModel.img]];
        
        _titleLbl.text = _attentionModel.title;
        _typeLbl.text = _attentionModel.liveType;
        _anchorLbl.text = _attentionModel.anchorName;
    }
}

@end
