//
//  SetTelCodeViewController.h
//  freemansec
//
//  Created by adamwu on 2017/7/22.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SetTelCodeViewControllerDelegate <NSObject>

- (void)SetTelCodeViewControllerTelCode:(NSString*)code;

@end

@interface SetTelCodeViewController : UIViewController
@property (nonatomic,assign) id<SetTelCodeViewControllerDelegate> delegate;
@end
