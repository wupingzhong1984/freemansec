//
//  NTESSendGiftAttachment.m
//  freemansec
//
//  Created by adamwu on 2017/11/23.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "NTESSendGiftAttachment.h"
#import "NTESSessionUtil.h"
#import "LiveGiftModel.h"

@implementation NTESSendGiftAttachment

- (NSString *)encodeAttachment
{
    NSDictionary *dict = @{CMType : @(CustomMessageTypeSendGift),
                           CMData : @{CMValue:self.giftId}};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:0
                                                     error:nil];
    NSString *content = nil;
    if (data) {
        content = [[NSString alloc] initWithData:data
                                        encoding:NSUTF8StringEncoding];
    }
    return content;
}

- (NSString *)cellContent:(NIMMessage *)message{
    return @"NTESSessionSendGiftContentView";
}

- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width{
    
    return self.showCoverImage.size;
}

- (UIEdgeInsets)contentViewInsets:(NIMMessage *)message
{
    if (message.session.sessionType == NIMSessionTypeChatroom)
    {
        CGFloat bubbleMarginTopForImage  = 15.f;
        CGFloat bubbleMarginLeftForImage = 12.f;
        return  UIEdgeInsetsMake(bubbleMarginTopForImage,bubbleMarginLeftForImage,0,0);
    }
    else
    {
        CGFloat bubbleMarginForImage    = 3.f;
        CGFloat bubbleArrowWidthForImage = 5.f;
        if (message.isOutgoingMsg) {
            return  UIEdgeInsetsMake(bubbleMarginForImage,bubbleMarginForImage,bubbleMarginForImage,bubbleMarginForImage + bubbleArrowWidthForImage);
        }else{
            return  UIEdgeInsetsMake(bubbleMarginForImage,bubbleMarginForImage + bubbleArrowWidthForImage, bubbleMarginForImage,bubbleMarginForImage);
        }
    }
}


- (NSString *)giftImgOnlineUrl
{
    if (_giftImgOnlineUrl == nil)
    {
        //todo
    }
    return _giftImgOnlineUrl;
}

- (BOOL)canBeRevoked
{
    return NO;
}

- (BOOL)canBeForwarded
{
    return NO;
}
@end
