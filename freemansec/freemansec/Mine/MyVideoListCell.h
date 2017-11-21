//
//  MyVideoListCell.h
//  freemansec
//
//  Created by adamwu on 2017/7/30.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "VideoModel.h"

@class MyVideoListCell;

@protocol MyVideoListCellDelegate <NSObject>

@optional
- (void)MyVideoListCell:(MyVideoListCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index;
- (void)MyVideoListCell:(MyVideoListCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index;
- (void)MyVideoListCell:(MyVideoListCell *)cell scrollingToState:(SWCellState)state;

@end


@interface MyVideoListCell : UITableViewCell

@property (nonatomic, strong) NSArray *leftUtilityButtons;
@property (nonatomic, strong) NSArray *rightUtilityButtons;
@property (nonatomic) id <MyVideoListCellDelegate> delegate;

@property (nonatomic,strong) VideoModel *videoModel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView leftUtilityButtons:(NSArray *)leftUtilityButtons rightUtilityButtons:(NSArray *)rightUtilityButtons;
- (void)hideUtilityButtonsAnimated:(BOOL)animated;

@end

@interface NSMutableArray (SWUtilityButtonsLeft)

- (void)addUtilityButtonWithColor:(UIColor *)color title:(NSString *)title;
- (void)addUtilityButtonWithColor:(UIColor *)color icon:(UIImage *)icon;
@end
