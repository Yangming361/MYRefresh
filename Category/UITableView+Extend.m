//
//  UITableView+Extend.m
//  MYCate
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 ahnu. All rights reserved.
//

#import "UITableView+Extend.h"


@implementation UITableView (Extend)
-(void)addRefreshView
{
    MYHeaderView *headerView = [MYHeaderView headerView];
    [self addSubview:headerView];
   }

-(void)stopRefreshDisplayWithStatus:(DataLoadRefreshStatus)status
{
    MYHeaderView *headerView = nil;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[MYHeaderView class]]) {
            headerView = (MYHeaderView *)view;
            break;
        }
    }
    [headerView stopAnimationWithStatus:status];
}

-(void)addDownloadView
{
    MYFooterView *footerView = [MYFooterView footerView];
    [self addSubview:footerView];
   
}

-(void)stopDownloadDisplayWithStatus:(DataLoadRefreshStatus)status
{
    MYFooterView *footerView = nil;
    for (UIView *view  in self.subviews) {
        if ([view isKindOfClass:[MYFooterView class]]) {
            
            footerView = (MYFooterView *)view;
            break;
        }
    }
    
    
    [footerView stopAnimationWithStatus:status];
}

-(void)setTitle:(NSString *)title status:(MYLoadViewStatus )status form:(TableViewLoadForm)form
{
    
    
    MYLoadView *loadView = nil;
    for (UIView *view in self.subviews) {
        if (form == TableViewLoadFormRefresh) {
            if ([view isKindOfClass:[MYHeaderView class]])
                loadView = (MYHeaderView *)view;
        }
        else if (form == TableViewLoadFormDown)
        {
            if ([view isKindOfClass:[MYFooterView class]])
                loadView = (MYFooterView *)view;
        }
    }
  
    switch (status) {
        case MYLoadViewStatusBeginDraging:
            [loadView setTitle:title status:status];
            break;
        case MYLoadViewStatusDraging:
            [loadView setTitle:title status:status];
            break;
        case MYLoadViewStatusLoading:
            [loadView setTitle:title status:status];
            break;
        default:
            break;
    }
}

@end
