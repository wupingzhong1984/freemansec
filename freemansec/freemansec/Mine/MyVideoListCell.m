//
//  MyVideoListCell.m
//  freemansec
//
//  Created by adamwu on 2017/7/30.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "MyVideoListCell.h"

@interface MyVideoListCell ()

@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UILabel *nameLbl;
@property (nonatomic,strong) UILabel *dateLbl;
@property (nonatomic,strong) UILabel *countLbl;
@end

@implementation MyVideoListCell

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
        
        self.dateLbl = [[UILabel alloc] init];
        _dateLbl.textColor = [UIColor lightGrayColor];
        _dateLbl.font = [UIFont systemFontOfSize:13];
        _dateLbl.x = _imgV.maxX + 10;
        _dateLbl.y = count.y - 10 - count.height;
        _dateLbl.height = count.height;
        _dateLbl.width = cellBg.maxX - 10 - _dateLbl.x;
        [self.contentView addSubview:_dateLbl];
        
        self.nameLbl = [[UILabel alloc] init];
        _nameLbl.textColor = [UIColor blackColor];
        _nameLbl.font = [UIFont systemFontOfSize:16];
        _nameLbl.x = count.x;
        _nameLbl.y = _imgV.y;
        _nameLbl.text = @"1";
        [_nameLbl sizeToFit];
        _nameLbl.width = cellBg.maxX - 10 - _nameLbl.x;
        [self.contentView addSubview:_nameLbl];
    }
    return self;
}

- (void)setVideoModel:(MyVideoModel*)videoModel {
    
    if (videoModel) {
        
        _videoModel = videoModel;
        
        [_imgV setImageWithURL:[NSURL URLWithString:_videoModel.videoImg]];
        
        _nameLbl.text = _videoModel.videoName;
        _dateLbl.text = _videoModel.date;
        _countLbl.text = _videoModel.playCount;
    }
}

@end
