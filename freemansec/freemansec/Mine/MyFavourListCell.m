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
        
        self.imgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 120, 90)];
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
        
        self.anchorLbl = [[UILabel alloc] init];
        _anchorLbl.textColor = [UIColor lightGrayColor];
        _anchorLbl.font = [UIFont systemFontOfSize:13];
        _anchorLbl.x = _imgV.maxX + 10;
        _anchorLbl.y = count.y - 10 - count.height;
        _anchorLbl.height = count.height;
        _anchorLbl.width = cellBg.maxX - 10 - _anchorLbl.x;
        [cellBg addSubview:_anchorLbl];
        
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

- (void)setVideoModel:(VideoModel *)videoModel{
    
    if (videoModel) {
        
        _videoModel = videoModel;
        
        [_imgV sd_setImageWithURL:[NSURL URLWithString:_videoModel.snapshotUrl] placeholderImage:[UIImage imageNamed:@"cover_place.png"]];
        
        _titleLbl.text = _videoModel.videoName;
        _anchorLbl.text = _videoModel.authorName;
        _countLbl.text = _videoModel.playCount;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
