//
//  Error.h
//  freemansec
//
//  Created by adamwu on 2017/7/13.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString* const SystemErrorDomain;

//错误类别
typedef enum
{
    SystemErrorWrongApiData = 1,
    SystemErrorUnknownError
    
} SystemError;

extern NSString* const SystemErrorMessageWrongApiData;
extern NSString* const SystemErrorMessageUnkownError;


