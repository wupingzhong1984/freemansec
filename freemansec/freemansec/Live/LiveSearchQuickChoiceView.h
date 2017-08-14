//
//  LiveSearchQuickChoiceView.h
//  freemansec
//
//  Created by adamwu on 2017/8/11.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LiveSearchQuickChoiceViewDelegate <NSObject>

-(void)LiveSearchQuickChoiceViewDelegateSearchWord:(NSString*)word;
-(void)LiveSearchQuickChoiceViewDelegateDidScroll;

@end

@interface LiveSearchQuickChoiceView : UIView

@property (nonatomic,assign) id<LiveSearchQuickChoiceViewDelegate> delegate;
- (id)initWithHeight:(CGFloat)height hotwords:(NSMutableArray*)hotwords history:(NSMutableArray*)history;
@end
