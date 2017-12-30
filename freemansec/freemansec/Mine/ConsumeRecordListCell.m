//
//  ConsumeRecordListCell.m
//  freemansec
//
//  Created by adamwu on 2017/11/24.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "ConsumeRecordListCell.h"

#define cell_height 60

@interface ConsumeRecordListCell ()

@property (nonatomic,strong) UILabel *typeLbl;
@property (nonatomic,strong) UILabel *amountLbl;
@property (nonatomic,strong) UILabel *dateLbl;
@property (nonatomic,strong) UILabel *timeLbl;

@end

@implementation ConsumeRecordListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.typeLbl = [[UILabel alloc] init];
        _typeLbl.textColor = [UIColor lightGrayColor];
        _typeLbl.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_typeLbl];
        
        self.amountLbl = [[UILabel alloc] init];
        _amountLbl.textColor = UIColor_dc8f23;
        _amountLbl.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_amountLbl];
        
        self.dateLbl = [[UILabel alloc] init];
        _dateLbl.textColor = UIColor_line_d2d2d2;
        _dateLbl.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_dateLbl];
        
        self.timeLbl = [[UILabel alloc] init];
        _timeLbl.textColor = UIColor_line_d2d2d2;
        _timeLbl.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_timeLbl];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, cell_height-0.5, K_UIScreenWidth, 0.5)];
        line.backgroundColor = UIColor_line_d2d2d2;
        [self.contentView addSubview:line];
    }
    return self;
}

- (void)setRecordModel:(ConsumeRecordModel *)recordModel {
    
    if (recordModel) {
        
        _typeLbl.text = recordModel.typeStr;
        [_typeLbl sizeToFit];
        _typeLbl.x = 22;
        _typeLbl.centerY = cell_height/2;
        
        _amountLbl.text = [NSString stringWithFormat:@"%@%@",
                           ([recordModel.typeId isEqualToString:@"1"]?@"+":@"-"),
                           recordModel.amount];
        [_amountLbl sizeToFit];
        _amountLbl.x = K_UIScreenWidth*2/5;
        _amountLbl.centerY = _typeLbl.centerY;
        
        NSDate *date = [LogicManager getDateByStr:recordModel.addTime format:@"yyyy/M/d HH:mm:ss"];
        
        _dateLbl.text = [LogicManager formatDate:date format:@"yyyy-MM-dd"];
        [_dateLbl sizeToFit];
        _dateLbl.x = K_UIScreenWidth - 22 - _dateLbl.width;
        _dateLbl.centerY = cell_height/2 - 8;
        
        _timeLbl.text = [LogicManager formatDate:date format:@"HH:mm"];
        [_timeLbl sizeToFit];
        _timeLbl.centerX = _dateLbl.centerX;
        _timeLbl.centerY = cell_height/2 + 8;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
