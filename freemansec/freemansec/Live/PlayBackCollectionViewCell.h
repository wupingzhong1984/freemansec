//
//  PlayBackCollectionViewCell.h
//  freemansec
//
//  Created by adamwu on 2017/9/1.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LivePlayBackModel.h"

@interface PlayBackCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) LivePlayBackModel *playBackModel;
@end
