//
//  MYFooterView.h
//  MYCate
//
//  Created by qianfeng on 15/9/23.
//  Copyright (c) 2015年 ahnu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYLoadView.h"


@interface MYFooterView : MYLoadView

@property(nonatomic,assign) MYLoadViewStatus status;


+ (id)footerView;



@end
