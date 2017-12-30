//
//  TopupProductView.h
//  freemansec
//
//  Created by adamwu on 2017/11/27.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopupProductView : UIView

@property (nonatomic,strong) NSString *productName;
@property (nonatomic,strong) NSString *costDesc;
@property (nonatomic,assign) BOOL selected;

@property (nonatomic,strong) UIButton *touchBtn;
@end
