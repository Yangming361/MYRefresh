//
//  UITableView+Extend.h
//  MYCate
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 ahnu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYFooterView.h"
#import "MYHeaderView.h"
@interface UITableView (Extend)
enum TableViewLoadForm
{
    TableViewLoadFormRefresh,
    TableViewLoadFormDown
};
typedef enum TableViewLoadForm TableViewLoadForm;
- (void)addRefreshView;

- (void)addDownloadView;

- (void)stopRefreshDisplayWithStatus:(DataLoadRefreshStatus )status;

- (void)stopDownloadDisplayWithStatus:(DataLoadRefreshStatus )status;

- (void)setTitle:(NSString *)title status:(MYLoadViewStatus )status form:(TableViewLoadForm )form;

@end
