//
//  MyVideoListCell.m
//  freemansec
//
//  Created by adamwu on 2017/7/30.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "MyVideoListCell.h"

static NSString * const kTableViewCellContentView = @"UITableViewCellContentView";

@interface SWUtilityButtonView : UIView

@property (nonatomic, strong) NSArray *utilityButtons;
@property (nonatomic, assign) CGFloat utilityButtonWidth;
@property (nonatomic, weak) MyVideoListCell *parentCell;
@property (nonatomic) SEL utilityButtonSelector;

- (id)initWithUtilityButtons:(NSArray *)utilityButtons parentCell:(MyVideoListCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector;

- (id)initWithFrame:(CGRect)frame utilityButtons:(NSArray *)utilityButtons parentCell:(MyVideoListCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector;

@end

@implementation SWUtilityButtonView

#pragma mark - SWUtilityButonView initializers

- (id)initWithUtilityButtons:(NSArray *)utilityButtons parentCell:(MyVideoListCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector {
    self = [super init];
    
    if (self) {
        
        self.utilityButtons = utilityButtons;
        self.utilityButtonWidth = [self calculateUtilityButtonWidth];
        self.parentCell = parentCell;
        self.utilityButtonSelector = utilityButtonSelector;
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame utilityButtons:(NSArray *)utilityButtons parentCell:(MyVideoListCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.utilityButtons = utilityButtons;
        self.utilityButtonWidth = [self calculateUtilityButtonWidth];
        self.parentCell = parentCell;
        self.utilityButtonSelector = utilityButtonSelector;
    }
    
    return self;
}

#pragma mark Populating utility buttons

- (CGFloat)calculateUtilityButtonWidth {
    CGFloat buttonWidth = kUtilityButtonWidthDefault;
    if (buttonWidth * _utilityButtons.count > kUtilityButtonsWidthMax) {
        CGFloat buffer = (buttonWidth * _utilityButtons.count) - kUtilityButtonsWidthMax;
        buttonWidth -= (buffer / _utilityButtons.count);
    }
    return buttonWidth;
}

- (CGFloat)utilityButtonsWidth {
    return (_utilityButtons.count * _utilityButtonWidth);
}

- (void)populateUtilityButtons {
    NSUInteger utilityButtonsCounter = 0;
    for (UIButton *utilityButton in _utilityButtons) {
        CGFloat utilityButtonXCord = 0;
        if (utilityButtonsCounter >= 1) utilityButtonXCord = _utilityButtonWidth * utilityButtonsCounter;
        [utilityButton setFrame:CGRectMake(utilityButtonXCord, 0, _utilityButtonWidth, CGRectGetHeight(self.bounds))];
        [utilityButton setTag:utilityButtonsCounter];
        [utilityButton addTarget:_parentCell action:_utilityButtonSelector forControlEvents:UIControlEventTouchDown];
        [self addSubview: utilityButton];
        utilityButtonsCounter++;
    }
}

@end


@interface MyVideoListCell ()
<UIScrollViewDelegate>
{
    SWCellState _cellState;
}

@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UILabel *titleLbl;
@property (nonatomic,strong) UILabel *dateLbl;
@property (nonatomic,strong) UILabel *countLbl;
// Scroll view to be added to UITableViewCell
@property (nonatomic, weak) UIScrollView *cellScrollView;

// The cell's height
@property (nonatomic) CGFloat height;

// Views that live in the scroll view
@property (nonatomic, weak) UIView *scrollViewContentView;
@property (nonatomic, strong) SWUtilityButtonView *scrollViewButtonViewLeft;
@property (nonatomic, strong) SWUtilityButtonView *scrollViewButtonViewRight;

// Used for row height and selection
@property (nonatomic, weak) UITableView *containingTableView;
@end

@implementation MyVideoListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView leftUtilityButtons:(NSArray *)leftUtilityButtons rightUtilityButtons:(NSArray *)rightUtilityButtons {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.rightUtilityButtons = rightUtilityButtons;
        self.leftUtilityButtons = leftUtilityButtons;
        self.height = 110;
        self.containingTableView = containingTableView;
        self.highlighted = NO;
        [self initializer];
        
        self.backgroundColor = [UIColor clearColor];
        
        UIView *cellBg = [[UIView alloc]
                          initWithFrame:CGRectMake(0,
                                                   0,
                                                   K_UIScreenWidth,
                                                   110)];
        cellBg.backgroundColor = [UIColor whiteColor];
        cellBg.clipsToBounds = YES;
        cellBg.layer.borderWidth = 0.5;
        cellBg.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self.contentView addSubview:cellBg];
        
        self.imgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 90, 90)];
        _imgV.contentMode = UIViewContentModeScaleAspectFit;
        [cellBg addSubview:_imgV];
        
        //NSLocalizedString
        UILabel *count = [UILabel createLabelWithFrame:CGRectZero text:NSLocalizedString(@"play count", nil) textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:13]];
        [count sizeToFit];
        count.x = _imgV.maxX + 10;
        count.y = _imgV.maxY - count.height;
        [cellBg addSubview:count];
        
        self.countLbl = [[UILabel alloc] init];
        _countLbl.textColor = [UIColor blackColor];
        _countLbl.font = count.font;
        _countLbl.x = count.maxX+2;
        _countLbl.y = count.y;
        _countLbl.height = count.height;
        _countLbl.width = cellBg.maxX - 10 - _countLbl.x;
        [cellBg addSubview:_countLbl];
        
        self.dateLbl = [[UILabel alloc] init];
        _dateLbl.textColor = [UIColor lightGrayColor];
        _dateLbl.font = [UIFont systemFontOfSize:13];
        _dateLbl.x = _imgV.maxX + 10;
        _dateLbl.y = count.y - 10 - count.height;
        _dateLbl.height = count.height;
        _dateLbl.width = cellBg.maxX - 10 - _dateLbl.x;
        [cellBg addSubview:_dateLbl];
        
        self.titleLbl = [[UILabel alloc] init];
        _titleLbl.textColor = [UIColor blackColor];
        _titleLbl.font = [UIFont systemFontOfSize:16];
        _titleLbl.x = count.x;
        _titleLbl.y = _imgV.y;
        _titleLbl.text = @"1";
        [_titleLbl sizeToFit];
        _titleLbl.width = cellBg.maxX - 10 - _titleLbl.x;
        [cellBg addSubview:_titleLbl];
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self initializer];
    }
    
    return self;
}

- (id)init {
    self = [super init];
    
    if (self) {
        [self initializer];
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initializer];
    }
    
    return self;
}

- (void)initializer {
    // Set up scroll view that will host our cell content
    UIScrollView *cellScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, K_UIScreenWidth, _height)];
    cellScrollView.contentSize = CGSizeMake(K_UIScreenWidth + [self utilityButtonsPadding], _height);
    cellScrollView.contentOffset = [self scrollViewContentOffset];
    cellScrollView.delegate = self;
    cellScrollView.showsHorizontalScrollIndicator = NO;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewPressed:)];
    [cellScrollView addGestureRecognizer:tapGestureRecognizer];
    
    self.cellScrollView = cellScrollView;
    
    // Set up the views that will hold the utility buttons
    SWUtilityButtonView *scrollViewButtonViewLeft = [[SWUtilityButtonView alloc] initWithUtilityButtons:_leftUtilityButtons parentCell:self utilityButtonSelector:@selector(leftUtilityButtonHandler:)];
    [scrollViewButtonViewLeft setFrame:CGRectMake([self leftUtilityButtonsWidth], 0, [self leftUtilityButtonsWidth], _height)];
    self.scrollViewButtonViewLeft = scrollViewButtonViewLeft;
    [self.cellScrollView addSubview:scrollViewButtonViewLeft];
    
    SWUtilityButtonView *scrollViewButtonViewRight = [[SWUtilityButtonView alloc] initWithUtilityButtons:_rightUtilityButtons parentCell:self utilityButtonSelector:@selector(rightUtilityButtonHandler:)];
    [scrollViewButtonViewRight setFrame:CGRectMake(CGRectGetWidth(self.bounds), 0, [self rightUtilityButtonsWidth], _height)];
    self.scrollViewButtonViewRight = scrollViewButtonViewRight;
    [self.cellScrollView addSubview:scrollViewButtonViewRight];
    
    // Populate the button views with utility buttons
    [scrollViewButtonViewLeft populateUtilityButtons];
    [scrollViewButtonViewRight populateUtilityButtons];
    
    // Create the content view that will live in our scroll view
    UIView *scrollViewContentView = [[UIView alloc] initWithFrame:CGRectMake([self leftUtilityButtonsWidth], 0, CGRectGetWidth(self.bounds), _height)];
    scrollViewContentView.backgroundColor = [UIColor clearColor];
    
    [self.cellScrollView addSubview:scrollViewContentView];
    self.scrollViewContentView = scrollViewContentView;
    
    // Add the cell scroll view to the cell
    UIView *contentViewParent = self;
    if (![NSStringFromClass([[self.subviews objectAtIndex:0] class]) isEqualToString:kTableViewCellContentView]) {
        // iOS 7
        contentViewParent = [self.subviews objectAtIndex:0];
    }
    NSArray *cellSubviews = [contentViewParent subviews];
    [self insertSubview:cellScrollView atIndex:0];
    for (UIView *subview in cellSubviews) {
        [self.scrollViewContentView addSubview:subview];
    }
}


- (void)setVideoModel:(VideoModel*)videoModel {
    
    if (videoModel) {
        
        _videoModel = videoModel;
        
        [_imgV sd_setImageWithURL:[NSURL URLWithString:_videoModel.snapshotUrl] placeholderImage:[UIImage imageNamed:@"cover_place_2.png"]];
        
        _titleLbl.text = _videoModel.videoName;
        _dateLbl.text = _videoModel.createTime;
        _countLbl.text = _videoModel.playCount;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark Selection

- (void)scrollViewPressed:(id)sender {
    if(_cellState == kCellStateCenter) {
        // Selection hack
        if ([self.containingTableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]){
            NSIndexPath *cellIndexPath = [_containingTableView indexPathForCell:self];
            [self.containingTableView.delegate tableView:_containingTableView didSelectRowAtIndexPath:cellIndexPath];
        }
        // Highlight hack
        if (!self.highlighted) {
            self.scrollViewButtonViewLeft.hidden = YES;
            self.scrollViewButtonViewRight.hidden = YES;
            NSTimer *endHighlightTimer = [NSTimer scheduledTimerWithTimeInterval:0.15 target:self selector:@selector(timerEndCellHighlight:) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:endHighlightTimer forMode:NSRunLoopCommonModes];
            [self setHighlighted:YES];
        }
    } else {
        // Scroll back to center
        [self hideUtilityButtonsAnimated:YES];
    }
}

- (void)timerEndCellHighlight:(id)sender {
    if (self.highlighted) {
        self.scrollViewButtonViewLeft.hidden = NO;
        self.scrollViewButtonViewRight.hidden = NO;
        [self setHighlighted:NO];
    }
}

#pragma mark UITableViewCell overrides

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self.scrollViewContentView.backgroundColor = backgroundColor;
}

#pragma mark - Utility buttons handling

- (void)rightUtilityButtonHandler:(id)sender {
    UIButton *utilityButton = (UIButton *)sender;
    NSInteger utilityButtonTag = [utilityButton tag];
    if ([_delegate respondsToSelector:@selector(MyVideoListCell:didTriggerRightUtilityButtonWithIndex:)]) {
        [_delegate MyVideoListCell:self didTriggerRightUtilityButtonWithIndex:utilityButtonTag];
    }
}

- (void)leftUtilityButtonHandler:(id)sender {
    UIButton *utilityButton = (UIButton *)sender;
    NSInteger utilityButtonTag = [utilityButton tag];
    if ([_delegate respondsToSelector:@selector(MyVideoListCell:didTriggerLeftUtilityButtonWithIndex:)]) {
        [_delegate MyVideoListCell:self didTriggerLeftUtilityButtonWithIndex:utilityButtonTag];
    }
}

- (void)hideUtilityButtonsAnimated:(BOOL)animated {
    // Scroll back to center
    [self.cellScrollView setContentOffset:CGPointMake([self leftUtilityButtonsWidth], 0) animated:animated];
    _cellState = kCellStateCenter;
    
    //    if ([_delegate respondsToSelector:@selector(leftSwippableTableViewCell:scrollingToState:)]) {
    //        [_delegate leftSwippableTableViewCell:self scrollingToState:kCellStateCenter];
    //    }
}


#pragma mark - Overriden methods

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.cellScrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), _height);
    self.cellScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) + [self utilityButtonsPadding], _height);
    self.cellScrollView.contentOffset = CGPointMake([self leftUtilityButtonsWidth], 0);
    self.scrollViewButtonViewLeft.frame = CGRectMake([self leftUtilityButtonsWidth], 0, [self leftUtilityButtonsWidth], _height);
    self.scrollViewButtonViewRight.frame = CGRectMake(CGRectGetWidth(self.bounds), 0, [self rightUtilityButtonsWidth], _height);
    self.scrollViewContentView.frame = CGRectMake([self leftUtilityButtonsWidth], 0, CGRectGetWidth(self.bounds), _height);
}

#pragma mark - Setup helpers

- (CGFloat)leftUtilityButtonsWidth {
    return [_scrollViewButtonViewLeft utilityButtonsWidth];
}

- (CGFloat)rightUtilityButtonsWidth {
    return [_scrollViewButtonViewRight utilityButtonsWidth];
}

- (CGFloat)utilityButtonsPadding {
    return ([_scrollViewButtonViewLeft utilityButtonsWidth] + [_scrollViewButtonViewRight utilityButtonsWidth]);
}

- (CGPoint)scrollViewContentOffset {
    return CGPointMake([_scrollViewButtonViewLeft utilityButtonsWidth], 0);
}

#pragma mark UIScrollView helpers

- (void)scrollToRight:(inout CGPoint *)targetContentOffset{
    targetContentOffset->x = [self utilityButtonsPadding];
    _cellState = kCellStateRight;
    
    if ([_delegate respondsToSelector:@selector(MyVideoListCell:scrollingToState:)]) {
        [_delegate MyVideoListCell:self scrollingToState:kCellStateRight];
    }
}

- (void)scrollToCenter:(inout CGPoint *)targetContentOffset {
    targetContentOffset->x = [self leftUtilityButtonsWidth];
    _cellState = kCellStateCenter;
    
    //    if ([_delegate respondsToSelector:@selector(leftSwippableTableViewCell:scrollingToState:)]) {
    //        [_delegate leftSwippableTableViewCell:self scrollingToState:kCellStateCenter];
    //    }
}

- (void)scrollToLeft:(inout CGPoint *)targetContentOffset{
    targetContentOffset->x = 0;
    _cellState = kCellStateLeft;
    
    //    if ([_delegate respondsToSelector:@selector(leftSwippableTableViewCell:scrollingToState:)]) {
    //        [_delegate leftSwippableTableViewCell:self scrollingToState:kCellStateLeft];
    //    }
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    switch (_cellState) {
        case kCellStateCenter:
            if (velocity.x >= 0.5f) {
                [self scrollToRight:targetContentOffset];
            } else if (velocity.x <= -0.5f) {
                [self scrollToLeft:targetContentOffset];
            } else {
                CGFloat rightThreshold = [self utilityButtonsPadding] - ([self rightUtilityButtonsWidth] / 2);
                CGFloat leftThreshold = [self leftUtilityButtonsWidth] / 2;
                if (targetContentOffset->x > rightThreshold)
                    [self scrollToRight:targetContentOffset];
                else if (targetContentOffset->x < leftThreshold)
                    [self scrollToLeft:targetContentOffset];
                else
                    [self scrollToCenter:targetContentOffset];
            }
            break;
        case kCellStateLeft:
            if (velocity.x >= 0.5f) {
                [self scrollToCenter:targetContentOffset];
            } else if (velocity.x <= -0.5f) {
                // No-op
            } else {
                if (targetContentOffset->x >= ([self utilityButtonsPadding] - [self rightUtilityButtonsWidth] / 2))
                    [self scrollToRight:targetContentOffset];
                else if (targetContentOffset->x > [self leftUtilityButtonsWidth] / 2)
                    [self scrollToCenter:targetContentOffset];
                else
                    [self scrollToLeft:targetContentOffset];
            }
            break;
        case kCellStateRight:
            if (velocity.x >= 0.5f) {
                // No-op
            } else if (velocity.x <= -0.5f) {
                [self scrollToCenter:targetContentOffset];
            } else {
                if (targetContentOffset->x <= [self leftUtilityButtonsWidth] / 2)
                    [self scrollToLeft:targetContentOffset];
                else if (targetContentOffset->x < ([self utilityButtonsPadding] - [self rightUtilityButtonsWidth] / 2))
                    [self scrollToCenter:targetContentOffset];
                else
                    [self scrollToRight:targetContentOffset];
            }
            break;
        default:
            break;
    }
}

#pragma mark ----------scroll-------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x > [self leftUtilityButtonsWidth]) {
        // Expose the right button view
        self.scrollViewButtonViewRight.frame = CGRectMake(scrollView.contentOffset.x + (CGRectGetWidth(self.bounds) - [self rightUtilityButtonsWidth]), 0.0f, [self rightUtilityButtonsWidth], _height);
    } else {
        // Expose the left button view
        self.scrollViewButtonViewLeft.frame = CGRectMake(scrollView.contentOffset.x, 0.0f, [self leftUtilityButtonsWidth], _height);
    }
}

@end


#pragma mark NSMutableArray class extension helper

@implementation NSMutableArray (SWUtilityButtonsLeft)

- (void)addUtilityButtonWithColor:(UIColor *)color title:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = color;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [self addObject:button];
}

- (void)addUtilityButtonWithColor:(UIColor *)color icon:(UIImage *)icon {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = color;
    [button setImage:icon forState:UIControlStateNormal];
    [self addObject:button];
}

@end
