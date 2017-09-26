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
@property (nonatomic,strong) UILabel *titleLbl;
@property (nonatomic,strong) UILabel *dateLbl;
@property (nonatomic,strong) UILabel *countLbl;
@end

@implementation MyVideoListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
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
        
        self.imgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 90, 90)];
        _imgV.contentMode = UIViewContentModeScaleAspectFit;
        [cellBg addSubview:_imgV];
        
        //NSLocalizedString
        UILabel *count = [UILabel createLabelWithFrame:CGRectZero text:NSLocalizedString(@"play count", nil) textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:13]];
        [count sizeToFit];
        count.x = _imgV.maxX + 10;
        count.y = _imgV.maxY - count.height;
        [cellBg addSubview:count];
        
        self.countLbl = [[UILabel alloc] init];
        _countLbl.textColor = [UIColor blackColor];
        _countLbl.font = count.font;
        _countLbl.x = count.maxX+2;
        _countLbl.y = count.y;
        _countLbl.height = count.height;
        _countLbl.width = cellBg.maxX - 10 - _countLbl.x;
        [cellBg addSubview:_countLbl];
        
        self.dateLbl = [[UILabel alloc] init];
        _dateLbl.textColor = [UIColor lightGrayColor];
        _dateLbl.font = [UIFont systemFontOfSize:13];
        _dateLbl.x = _imgV.maxX + 10;
        _dateLbl.y = count.y - 10 - count.height;
        _dateLbl.height = count.height;
        _dateLbl.width = cellBg.maxX - 10 - _dateLbl.x;
        [cellBg addSubview:_dateLbl];
        
        self.titleLbl = [[UILabel alloc] init];
        _titleLbl.textColor = [UIColor blackColor];
        _titleLbl.font = [UIFont systemFontOfSize:16];
        _titleLbl.x = count.x;
        _titleLbl.y = _imgV.y;
        _titleLbl.text = @"1";
        [_titleLbl sizeToFit];
        _titleLbl.width = cellBg.maxX - 10 - _titleLbl.x;
        [cellBg addSubview:_titleLbl];
    }
    return self;
}

- (void)setVideoModel:(VideoModel*)videoModel {
    
    if (videoModel) {
        
        _videoModel = videoModel;
        
        [_imgV sd_setImageWithURL:[NSURL URLWithString:_videoModel.snapshotUrl] placeholderImage:[UIImage imageNamed:@"cover_place_2.png"]];
        
        _titleLbl.text = _videoModel.videoName;
        _dateLbl.text = _videoModel.createTime;
        _countLbl.text = _videoModel.playCount;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
