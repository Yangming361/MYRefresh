//
//  MYHeaderView.h
//  MYCate
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 ahnu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYLoadView.h"

@interface MYHeaderView : MYLoadView

@property(nonatomic,assign) MYLoadViewStatus status;

+ (id)headerView;

@end
