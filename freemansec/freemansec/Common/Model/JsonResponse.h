//
//  JsonResponse.h
//  freemansec
//
//  Created by adamwu on 2017/7/13.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"


@interface JsonResponse : JSONModel


@property (nonatomic, strong) NSString<Optional>* code;
@property (nonatomic, strong) NSString<Optional>* message;
@property (nonatomic, strong) id<Optional> data;


@end
