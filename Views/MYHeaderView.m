//
//  MYHeaderView.m
//  MYCate
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 ahnu. All rights reserved.
//

#import "MYHeaderView.h"
@interface MYHeaderView()
{
    NSString *_beginDragTitle;
    NSString *_dragTitle;
    NSString *_refreshTitle;
    
}
@property(nonatomic,weak) UIScrollView *scrollView;

@property(nonatomic,weak)UIButton *alertButtonView;
@property(nonatomic,weak)UIView *refreshView;

@property(nonatomic,weak) UILabel *completeLabel;
@end
@implementation MYHeaderView

-(void)stopAnimationWithStatus:(DataLoadRefreshStatus)status
{
    
    
     self.refreshView.hidden = YES;
    switch (status) {
        case DataRefreshStatusSucceed:
           
            self.completeLabel.text = @"😄刷新成功";
            break;
        case DataRefreshStatusFailed:
            self.completeLabel.text = @"😭刷新失败";
            break;
        default:
            break;
    }
    
    [self performSelector:@selector(disapperarRefreshView) withObject:nil afterDelay:1];
   
}

- (void)disapperarRefreshView
{
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self clear];
    
    //设置刷新初始状态
    self.status = MYLoadViewStatusBeginDraging;
    
}

- (void)clear
{
    [self.refreshView removeFromSuperview];
    [self.alertButtonView removeFromSuperview];
    [self.completeLabel removeFromSuperview];
}
-(void)setScrollView:(UIScrollView *)scrollView
{
    
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    _scrollView = scrollView;
    
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
   
}

-(UILabel *)completeLabel
{
    if (_completeLabel == nil) {
        
        UILabel *completeLabel = [[UILabel alloc] initWithFrame:self.bounds];
        completeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:completeLabel];
        _completeLabel = completeLabel;
    }
    return _completeLabel;
}

- (UIView *)refreshView
{
    if (_refreshView == nil) {
        
        UIView *view = [[UIView alloc] initWithFrame:self.bounds];
        
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activity.frame = CGRectMake(75, 5, 50, 50);
        [view addSubview:activity];
        [activity startAnimating];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:titleLabel];
        titleLabel.text =_dragTitle?(_dragTitle):(@"正在刷新~~~");
        
        [self addSubview:view];
        _refreshView = view;
        
    }
    return _refreshView;
}

-(UIButton *)alertButtonView
{
    if (_alertButtonView == nil) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
        //button.titleEdgeInsets = UIEdgeInsetsMake(0, -80, 0, 80);
        [self addSubview:button];
        button.frame = self.bounds;
        _alertButtonView = button;
    }
    return _alertButtonView;
}

-(void)setTitle:(NSString *)title status:(MYLoadViewStatus)status
{
    switch (status) {
        case MYLoadViewStatusBeginDraging:
            _beginDragTitle = title;
            break;
            
        case MYLoadViewStatusDraging:
          _dragTitle = title;
            break;
            
        case MYLoadViewStatusLoading:
            _refreshTitle = title;
            break;
            
        default:
            break;
    }
}

-(void)setStatus:(MYLoadViewStatus)status
{
     _status =status;
    switch (status) {
        case MYLoadViewStatusBeginDraging:
            
            [self.alertButtonView setTitle:_beginDragTitle?(_beginDragTitle):(@"正在拖拽~~~") forState:UIControlStateNormal];
            break;
            
        case MYLoadViewStatusDraging:
             [ self.alertButtonView setTitle:_dragTitle?(_dragTitle):(@"松开即可刷新~~~") forState:UIControlStateNormal];
            break;
            
        case MYLoadViewStatusLoading:
            self.alertButtonView.hidden = YES;
            self.refreshView;
            break;
            
        default:
            break;
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    //如果当前正在刷新，则直接return
    if(self.status ==MYLoadViewStatusLoading)
        return;
    
    [self willMoveToSuperview:self.scrollView];
    CGFloat maxY = -self.frame.size.height;
    if (self.scrollView.isDragging) {
        
       
        if (self.scrollView.contentOffset.y < 0 && self.scrollView.contentOffset.y > maxY) {
            
            [self setStatus:MYLoadViewStatusBeginDraging];
        }else if (self.scrollView.contentOffset.y<maxY)
        {
            
            [self setStatus:MYLoadViewStatusDraging];
        }
        
    }else if(self.status == MYLoadViewStatusDraging)
        {
            [self setStatus:MYLoadViewStatusLoading];
            self.scrollView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
           
        }
    
}

+(id)headerView
{
    return [[self alloc] init];
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    CGFloat selfX = 0;
    CGFloat selfY = -60;
    CGFloat selfW = newSuperview.frame.size.width;
    CGFloat selfH = 60;
    
    self.frame = CGRectMake(selfX, selfY, selfW, selfH);
   // self.backgroundColor = [UIColor yellowColor];
}

- (void)didMoveToSuperview
{
    self.scrollView = (UITableView *)self.superview;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
