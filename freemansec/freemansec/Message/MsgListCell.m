//
//  MsgListCell.m
//  freemansec
//
//  Created by adamwu on 2017/8/24.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "MsgListCell.h"

@interface MsgListCell ()

@property (nonatomic,strong) UILabel *nameLbl;
@property (nonatomic,strong) UILabel *dateLbl;
@property (nonatomic,strong) UILabel *contentLbl;
@property (nonatomic,strong) UIView *line;
@property (nonatomic,strong) UIView *isReadIcon;
@end

@implementation MsgListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *imgBg = [[UIView alloc] init];
        imgBg.backgroundColor = UIColor_82b432;
        imgBg.size = (CGSize){50,50};
        imgBg.x = 20;
        imgBg.centerY = 72/2;
        imgBg.layer.cornerRadius = imgBg.width/2;
        [self.contentView addSubview:imgBg];
        
        UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"msg_cell_icon.png"]];
        imgV.center = imgBg.center;
        [self.contentView addSubview:imgV];
        
        self.nameLbl = [[UILabel alloc] init];
        _nameLbl.font = [UIFont systemFontOfSize:20];
        _nameLbl.textColor = [UIColor blackColor];
        _nameLbl.text = @"1";
        [_nameLbl sizeToFit];
        _nameLbl.x = imgV.maxX + 10;
        _nameLbl.centerY = imgV.centerY - 10;
        [self.contentView addSubview:_nameLbl];
        
        self.dateLbl = [[UILabel alloc] init];
        _dateLbl.font = [UIFont systemFontOfSize:15];
        _dateLbl.textColor = [UIColor lightGrayColor];
        _dateLbl.text = @"1";
        [_dateLbl sizeToFit];
        _dateLbl.x = K_UIScreenWidth - 20 - _dateLbl.width;
        _dateLbl.centerY = _nameLbl.centerY;
        [self.contentView addSubview:_dateLbl];
        
        self.contentLbl = [[UILabel alloc] init];
        _contentLbl.font = [UIFont systemFontOfSize:15];
        _contentLbl.textColor = [UIColor lightGrayColor];
        _contentLbl.numberOfLines = 0;
        _contentLbl.x = _nameLbl.x;
        _contentLbl.y = imgV.centerY+5;
        [self.contentView addSubview:_contentLbl];
        
        self.line = [[UIView alloc] initWithFrame:CGRectMake(10, 0, K_UIScreenWidth-20, 0.5)];
        _line.backgroundColor = UIColor_line_d2d2d2;
        [self.contentView addSubview:_line];
        
        self.isReadIcon = [[UIView alloc] init];
        _isReadIcon.size = CGSizeMake(8, 8);
        _isReadIcon.backgroundColor = [UIColor redColor];
        _isReadIcon.layer.cornerRadius = _isReadIcon.width/2;
        _isReadIcon.centerX = 20/2;
        _isReadIcon.centerY = imgBg.centerY;
        [self.contentView addSubview:_isReadIcon];
        
    }
    return self;
}

- (void)setMsgModel:(MsgModel *)msgModel {
    
    if (msgModel) {
        
        _msgModel = msgModel;
        
        _dateLbl.text = _msgModel.time;
        [_dateLbl sizeToFit];
        _dateLbl.x = K_UIScreenWidth - 20 - _dateLbl.width;
        
        _nameLbl.text = _msgModel.senderUser;
        _nameLbl.width = _dateLbl.x - 10 - _nameLbl.x;
        
        _contentLbl.width = K_UIScreenWidth - 10 - _contentLbl.x;
        [Utility formatLabel:_contentLbl text:_msgModel.content font:_contentLbl.font lineSpacing:5];
        
        _line.y = _contentLbl.maxY + 10 - 0.5;
        
        _isReadIcon.hidden = ![_msgModel.isRead isEqualToString:@"0"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
