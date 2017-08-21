//
//  FSChatroomViewController.m
//  freemansec
//
//  Created by adamwu on 2017/8/19.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "FSChatroomViewController.h"
#import "FSChatroomConfig.h"
#import "NTESSessionMsgConverter.h"
#import "NTESChatroomManager.h"

@interface FSChatroomViewController ()
{
    BOOL _isRefreshing;
}
@property (nonatomic,strong) FSChatroomConfig *config;
@property (nonatomic,strong) NIMChatroom *chatroom;
@end

@implementation FSChatroomViewController

- (instancetype)initWithChatroom:(NIMChatroom *)chatroom  withRect:(CGRect)rect
{
    self = [super initWithSession:[NIMSession session:chatroom.roomId type:NIMSessionTypeChatroom] withRect:rect];
    if (self) {
        _chatroom = chatroom;
    }
    return self;
}

- (void)dealloc
{
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (id<NIMSessionConfig>)sessionConfig{
    return self.config;
}


//- (BOOL)onTapMediaItem:(NIMMediaItem *)item
//{
//    SEL  sel = item.selctor;
//    BOOL response = [self respondsToSelector:sel];
//    if (response) {
//        SuppressPerformSelectorLeakWarning([self performSelector:sel withObject:item]);
//    }
//    return response;
//}
//
//- (void)onTapMediaItemJanKenPon:(NIMMediaItem *)item{
//    NTESJanKenPonAttachment *attachment = [[NTESJanKenPonAttachment alloc] init];
//    attachment.value = arc4random() % 3 + 1;
//    [self sendMessage:[NTESSessionMsgConverter msgWithJenKenPon:attachment]];
//}

- (void)sendMessage:(NIMMessage *)message
{
    NIMChatroomMember *member = [[NTESChatroomManager sharedInstance] myInfo:self.chatroom.roomId];
    message.remoteExt = @{@"type":@(member.type)};
    [super sendMessage:message];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat offset = 44.f;
        if (self.tableView.contentOffset.y <= -offset && !_isRefreshing && self.tableView.isDragging) {
            _isRefreshing = YES;
            UIRefreshControl *refreshControl = [self findRefreshControl];
            [refreshControl beginRefreshing];
            [refreshControl sendActionsForControlEvents:UIControlEventValueChanged];
            [self.tableView endEditing:YES];
        }
        else if(self.tableView.contentOffset.y >= 0)
        {
            _isRefreshing = NO;
        }
    }
}

- (UIRefreshControl *)findRefreshControl
{
    for (UIRefreshControl *subView in self.tableView.subviews) {
        if ([subView isKindOfClass:[UIRefreshControl class]]) {
            return subView;
        }
    }
    return nil;
}

#pragma mark - Get
- (FSChatroomConfig *)config{
    if (!_config) {
        _config = [[FSChatroomConfig alloc] initWithChatroom:self.chatroom.roomId];
    }
    return _config;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
