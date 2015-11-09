//
//  MYLoadView.h
//  MYCate
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 ahnu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYLoadView : UIView
enum DataLoadRefreshStatus
{
    DataLoadStatusSucceed,
    DataLoadStatusFailed,
    DataRefreshStatusSucceed,
    DataRefreshStatusFailed
};
typedef enum DataLoadRefreshStatus DataLoadRefreshStatus;
enum MYLoadViewStatus
{
    MYLoadViewStatusBeginDraging,
    MYLoadViewStatusDraging,
    MYLoadViewStatusLoading
};
typedef enum MYLoadViewStatus MYLoadViewStatus;

- (void)stopAnimationWithStatus:(DataLoadRefreshStatus )status;

- (void)setTitle:(NSString *)title status:(MYLoadViewStatus )status;
@end
