//
//  LiveProgramCellView.m
//  freemansec
//
//  Created by adamwu on 2017/8/31.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "LiveProgramCellView.h"

@implementation LiveProgramCellView

- (id)initWithProgram:(LiveProgramModel*)program width:(CGFloat)width {
    
    if (self = [super initWithFrame:CGRectZero]) {
        
        self.width = width;
        
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"liveprogram_icon.png"]];
        icon.centerY = 22/2;
        [self addSubview:icon];
        
        NSString *stateStr;
        UIColor *stateColor;
        if ([program.status isEqualToString:@"2"]) {
            stateStr = @"已播放";
            stateColor = UIColor_line_d2d2d2;
        } else if ([program.status isEqualToString:@"1"]) {
            stateStr = @"正在播放";
            stateColor = [UIColor lightGrayColor];
        } else {
            stateStr = @"未播放";
            stateColor = [UIColor lightGrayColor];
        }
        UILabel *state = [UILabel createLabelWithFrame:CGRectZero text:stateStr textColor:stateColor font:[UIFont systemFontOfSize:12]];
        [state sizeToFit];
        state.centerY = 22/2;
        state.x = self.width - state.width;
        [self addSubview:state];
        
        UILabel *time = [UILabel createLabelWithFrame:CGRectZero text:program.startTime textColor:UIColor_line_d2d2d2 font:[UIFont systemFontOfSize:12]];
        [time sizeToFit];
        time.centerY = 22/2;
        time.x = 22;
        [self addSubview:time];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(time.x, 22, self.width-time.x, 0.5)];
        line.backgroundColor = UIColor_line_d2d2d2;
        [self addSubview:line];
        
        UILabel *title = [UILabel createLabelWithFrame:CGRectZero text:program.title textColor:UIColor_82b432 font:[UIFont systemFontOfSize:12]];
        [title sizeToFit];
        title.lineBreakMode = NSLineBreakByTruncatingTail;
        title.x = line.x;
        title.width = line.width;
        title.centerY = 20/2 + line.y;
        [self addSubview:title];
        
        UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(line.x, line.y + 20, line.width, 0)];
        desc.numberOfLines = 0;
        desc.textColor = [UIColor lightGrayColor];
        [Utility formatLabel:desc text:program.desc font:[UIFont systemFontOfSize:10] lineSpacing:5];
        [self addSubview:desc];
        self.height = desc.maxY;
    }
    
    return self;
}

@end
