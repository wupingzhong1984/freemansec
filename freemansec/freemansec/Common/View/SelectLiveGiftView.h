//
//  SelectLiveGiftView.h
//  freemansec
//
//  Created by adamwu on 2017/11/27.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectLiveGiftViewDelegate <NSObject>
- (void)presentGiftByIndex:(NSInteger)index;
@end

@interface SelectLiveGiftView : UIView
@property (nonatomic,assign) id<SelectLiveGiftViewDelegate> delegate;
@end
