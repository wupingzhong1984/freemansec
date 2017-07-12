//
//  LiveKindViewController.m
//  freeemansec
//
//  Created by adamwu on 2017/7/1.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "LiveKindViewController.h"
#import <AVFoundation/AVFoundation.h>
#import<MediaPlayer/MediaPlayer.h>
#import<CoreMedia/CoreMedia.h>

@interface LiveKindViewController ()
@end

@implementation LiveKindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([_kindId isEqualToString:@"1"]) {
        
        self.view.backgroundColor = [UIColor redColor];
    } else if ([_kindId isEqualToString:@"2"]) {
        
        self.view.backgroundColor = [UIColor orangeColor];
    } else {
        
        self.view.backgroundColor = [UIColor yellowColor];
    }
    
    
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
