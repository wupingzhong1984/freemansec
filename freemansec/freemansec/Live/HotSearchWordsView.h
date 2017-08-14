//
//  HotSearchWordsView.h
//  freemansec
//
//  Created by adamwu on 2017/8/11.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HotSearchWordsViewDelegate <NSObject>

- (void)HotSearchWordsViewDelegateSelectedWord:(NSString*)word;

@end

@interface HotSearchWordsView : UIView

@property (nonatomic,assign) id<HotSearchWordsViewDelegate> delegate;
- (id)initWithStrs:(NSMutableArray*)strs width:(CGFloat)width;

@end
