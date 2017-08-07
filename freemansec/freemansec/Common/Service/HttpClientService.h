//
//  HttpClientService.h
//  freemansec
//
//  Created by adamwu on 2017/7/13.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonResponse.h"

typedef void (^HttpClientServiceObjectBlock)(id obj, NSError* err);

extern NSString* const LogicErrorDomain;

typedef enum  {
    HttpReuqestMethodGet,
    HttpReuqestMethodPost,
    HttpReuqestMethodPut,
    HttpReuqestMethodDelete
} HttpReuqestMethod;


@interface HttpClientService : NSObject

-(void) httpRequestMethod:(HttpReuqestMethod) method
    path:(NSString*)path
      params:(NSDictionary*)params
  completion:(HttpClientServiceObjectBlock)completion;


@end
