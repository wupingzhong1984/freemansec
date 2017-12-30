//
//  NTESSendGiftAttachment.h
//  freemansec
//
//  Created by adamwu on 2017/11/23.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTESCustomAttachmentDefines.h"

@interface NTESSendGiftAttachment : NSObject<NIMCustomAttachment,NTESCustomAttachmentInfo>

@property (nonatomic,strong) NSString *giftId;
@property (nonatomic,strong) NSString *giftImgOnlineUrl;
@end
