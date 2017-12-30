//
//  LiveGiftView.h
//  freemansec
//
//  Created by adamwu on 2017/11/27.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveGiftView : UIView

@property (nonatomic,strong) NSString *giftImgUrl;
@property (nonatomic,strong) NSString *giftName;
@property (nonatomic,strong) NSString *coin;

@property (nonatomic,strong) UIImageView *bgImgV;
@property (nonatomic,strong) UIButton *touchBtn;
@end
