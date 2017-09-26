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
//@property (nonatomic,strong) UIImageView *headIV;
@property (nonatomic,strong) UILabel *anchor;
@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) UIView *living;
@property (nonatomic,strong) UILabel *stateLbl;
@property (nonatomic,strong) UIView *stateLight;
@property (nonatomic,strong) UIImageView *playCountIcon;
@property (nonatomic,strong) UILabel *playCountLbl;

@end

@implementation LiveSearchResultCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        
        self.coverIV = [[UIImageView alloc] init];
        _coverIV.size = CGSizeMake(self.width, self.width);
        _coverIV.contentMode = UIViewContentModeScaleAspectFill;
        _coverIV.clipsToBounds = YES;
        [self addSubview:_coverIV];
        
//        self.headIV = [[UIImageView alloc] init];
//        _headIV.size = CGSizeMake(35, 35);
//        _headIV.clipsToBounds = YES;
//        _headIV.layer.cornerRadius = _headIV.width/2;
//        [self addSubview:_headIV];
        
        self.anchor = [[UILabel alloc] init];
        _anchor.font = [UIFont systemFontOfSize:14];
        _anchor.textAlignment = NSTextAlignmentLeft;
        _anchor.lineBreakMode = NSLineBreakByTruncatingTail;
        _anchor.textColor = [UIColor blackColor];
        [self addSubview:_anchor];
        
        self.title = [[UILabel alloc] init];
        _title.font = [UIFont systemFontOfSize:14];
        _title.textAlignment = NSTextAlignmentLeft;
        _title.lineBreakMode = NSLineBreakByTruncatingTail;
        _title.textColor = [UIColor lightGrayColor];
        [self addSubview:_title];
        
        self.playCountIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"play_count_gray.png"]];
        [self addSubview:_playCountIcon];
        
        self.playCountLbl = [[UILabel alloc] init];
        _playCountLbl.font = [UIFont systemFontOfSize:12];
        _playCountLbl.textColor = [UIColor lightGrayColor];
        [self addSubview:_playCountLbl];
        
        self.stateLight = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
        _stateLight.layer.cornerRadius = 3;
        _stateLight.backgroundColor = [UIColor greenColor];
        
        self.stateLbl = [UILabel createLabelWithFrame:CGRectZero text:NSLocalizedString(@"living",nil) textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:13]];
        [_stateLbl sizeToFit];
        
        self.living = [[UIView alloc] init];
        _living.size = CGSizeMake(_stateLight.width + _stateLbl.width + 18, 20);
        _living.y = _coverIV.y + 7;
        _living.x = self.width - 7 - _living.width;
        _living.layer.cornerRadius = _living.height/2;
        _living.layer.borderColor = [UIColor whiteColor].CGColor;
        _living.layer.borderWidth = 0.5;
        _living.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        [self addSubview:_living];
        
        _stateLight.centerY = _living.height/2;
        _stateLight.x = 6;
        [_living addSubview:_stateLight];
        
        _stateLbl.x = _stateLight.maxX + 6;
        _stateLbl.centerY = _stateLight.centerY;
        [_living addSubview:_stateLbl];
        
    }
    
    return self;
}

- (void)setResultModel:(LiveSearchResultModel *)resultModel {
    
    if (resultModel) {
        
        [self.coverIV sd_setImageWithURL:[NSURL URLWithString:resultModel.liveImg] placeholderImage:[UIImage imageNamed:@"cover_place_2.png"]];
//        [self.headIV sd_setImageWithURL:[NSURL URLWithString:resultModel.headImg] placeholderImage:[UIImage imageNamed:@"cover_place_2.png"]];
//        _headIV.x = 5;
//        _headIV.centerY = 50/2 + _coverIV.maxY;
//        _headIV.hidden = YES;
        
        _anchor.text = resultModel.nickName;
        [_anchor sizeToFit];
        _anchor.x = 10;
        _anchor.centerY = 50/2 + _coverIV.maxY - 9;
        _anchor.width = _coverIV.maxX - _anchor.x*2;
        
        _title.text = resultModel.liveName;
        [_title sizeToFit];
        _title.x = 10;
        _title.centerY = 50/2 + _coverIV.maxY + 9;
        _title.width = _anchor.width;
        
        _playCountLbl.text = [NSString stringWithFormat:@"%d",[resultModel.onlineusercount intValue]];
        [_playCountLbl sizeToFit];
        
        _playCountLbl.hidden = NO;
        _playCountIcon.hidden = NO;
        _living.hidden = NO;
        
        if ([resultModel.state isEqualToString:@"1"] || [resultModel.state isEqualToString:@"3"]) {
            
            _stateLight.backgroundColor = [UIColor greenColor];
            _stateLbl.text = NSLocalizedString(@"living", nil);
            [_stateLbl sizeToFit];
            
        } else if (resultModel.vid.length > 0) {
            
            _stateLight.backgroundColor = [UIColor orangeColor];
            _stateLbl.text = NSLocalizedString(@"playback", nil);
            [_stateLbl sizeToFit];
            
        } else {
            
            _playCountLbl.hidden = YES;
            _playCountIcon.hidden = YES;
            _living.hidden = YES;
        }
        
        _living.size = CGSizeMake(_stateLight.width + _stateLbl.width + 18, 20);
        _living.x = self.width - 7 - _living.width;
        _stateLight.x = 6;
        _stateLbl.x = _stateLight.maxX + 6;
        
        _playCountLbl.centerY = _anchor.centerY;
        _playCountLbl.x = self.width - 10 - _playCountLbl.width;
        _playCountIcon.centerY = _playCountLbl.centerY;
        _playCountIcon.x = _playCountLbl.x - 5 - _playCountIcon.width;
        _anchor.width = _playCountIcon.x - 5 - _anchor.x;
    }
}

- (void)setSelected:(BOOL)selected {
    
    
}
@end
