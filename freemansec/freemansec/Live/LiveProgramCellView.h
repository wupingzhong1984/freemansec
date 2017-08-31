//
//  LiveProgramCellView.h
//  freemansec
//
//  Created by adamwu on 2017/8/31.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveProgramModel.h"

@interface LiveProgramCellView : UIView

- (id)initWithProgram:(LiveProgramModel*)program width:(CGFloat)width;

@end
