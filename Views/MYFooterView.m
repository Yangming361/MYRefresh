//
//  MYFooterView.m
//  MYCate
//
//  Created by qianfeng on 15/9/23.
//  Copyright (c) 2015年 ahnu. All rights reserved.
//


#import "MYFooterView.h"

@interface MYFooterView ()
@property(nonatomic,weak) UIScrollView *scrollView;

@property(nonatomic,weak) UIButton *alertButtonView;

@property(nonatomic,weak) UIView *loadView;

@property(nonatomic,weak) UILabel *completeLabel;

@property(nonatomic,copy) NSString *beginDragTitle;
@property(nonatomic,copy) NSString *dragTitle;
@property(nonatomic,copy) NSString *loadTitle;
@end



@implementation MYFooterView
//周一之前上传到git
-(void)setScrollView:(UIScrollView *)scrollView
{
    
    //移除旧的监听
      [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    _scrollView = scrollView;
  
    //添加新的监听
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
  //  [scrollView addSubview:self];
    
}

-(void)stopAnimationWithStatus:(DataLoadRefreshStatus)status
{
    
    self.loadView.hidden = YES;
    switch (status) {
        case DataLoadStatusSucceed:
            self.completeLabel.text = @"😄下载成功";
                    break;
        case DataLoadStatusFailed:
              self.completeLabel.text = @"😭下载失败";
            break;
        default:
            break;
    }
    //3s之后将loadView移除
    [self performSelector:@selector(disapperarLoadView) withObject:nil afterDelay:1];
    
    
}

- (void)disapperarLoadView
{
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self clear];
    //重新设置初始状态
    self.status = MYLoadViewStatusBeginDraging;
}

//将alertButtonView，loadView移除
- (void)clear
{
    [self.alertButtonView removeFromSuperview];
    [self.loadView removeFromSuperview];
    [self.completeLabel removeFromSuperview];
}

-(void)dealloc
{
    
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    //当前状态为正在加载时，直接返回，避免再次调用代理回调请求加载状态
    if (self.status == MYLoadViewStatusLoading)
        return;
    
   [self willMoveToSuperview:self.scrollView];
       if (self.scrollView.isDragging) {
        //scrollView 正在拖拽
        
        CGFloat maxY = self.scrollView.contentSize.height - self.scrollView.frame.size.height;
        
        CGFloat footerViewHeight = 60;
        
        if (self.scrollView.contentOffset.y >= maxY  && self.scrollView.contentOffset.y < maxY +footerViewHeight ) {
            
            [self setStatus:MYLoadViewStatusBeginDraging];
            
        }else if (self.scrollView.contentOffset.y >= maxY +footerViewHeight)
        {
            [self setStatus:MYLoadViewStatusDraging];
        }
        
    }else
    {
        if (self.status == MYLoadViewStatusDraging) {
            [self setStatus:MYLoadViewStatusLoading];
            
            self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, self.frame.size.height, 0);
            
        }
        
    }
}

-(UIView *)completeLabel
{
    if (_completeLabel == nil) {
        
        UILabel *completeLabel = [[UILabel alloc] initWithFrame:self.bounds];
        completeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:completeLabel];
        _completeLabel = completeLabel;
    }
    return _completeLabel;
}

-(UIView *)loadView
{
    if (_loadView == nil) {
        
        UIView *view = [[UIView alloc] initWithFrame:self.bounds];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:16];
        [view addSubview:titleLabel];
        titleLabel.text = @"正在加载~";
        if (_loadTitle!= nil) {
            titleLabel.text = _loadTitle;
        }
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.frame = CGRectMake(90, 10, 40, 40);
        [view addSubview:activityView];
        
        [self addSubview:view];
        
        _loadView = view;
        
    }
    
    return _loadView;
}

-(UIButton *)alertButtonView
{
    if (_alertButtonView == nil) {
    
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
        button.frame = self.bounds;
        [self addSubview:button];
        _alertButtonView = button;
    }
    
    return _alertButtonView;
}


-(void)setStatus:(MYLoadViewStatus)status
{
    _status = status;
    
    switch (status) {
        case MYLoadViewStatusBeginDraging:
            [self.alertButtonView setTitle:@"拖拽加载更多~" forState:UIControlStateNormal];
            if (_beginDragTitle != nil) {
                
                [self.alertButtonView setTitle:_beginDragTitle forState:UIControlStateNormal];
            }
            break;
        case MYLoadViewStatusDraging:
            [ self.alertButtonView setTitle:@"松开加载更多~" forState:UIControlStateNormal];
            if (_beginDragTitle != nil) {
                
                [self.alertButtonView setTitle:_dragTitle forState:UIControlStateNormal];
            }
            break;
        case MYLoadViewStatusLoading:
            self.alertButtonView.hidden = YES;
            self.loadView;
            break;
        default:
            break;
    }
    
    
}

- (void)setTitle:(NSString *)title status:(MYLoadViewStatus)status
{
    switch (status) {
        case MYLoadViewStatusBeginDraging:
            self.beginDragTitle = title;
            break;
        case MYLoadViewStatusDraging:
            self.dragTitle = title;
            break;
        case MYLoadViewStatusLoading:
            self.loadTitle = title;
            break;
        default:
            break;
    }
}

+(id)footerView
{
    return [[self alloc] init];
}


-(void)willMoveToSuperview:(UIView *)newSuperview
{
    UITableView *tableView = (UITableView *)newSuperview;
    
    CGFloat selfX = 0;
    CGFloat selfY = tableView.contentSize.height;
    
    
    
    CGFloat selfW = tableView.frame.size.width;
    CGFloat selfH = 60;
    
    self.frame = CGRectMake(selfX, selfY, selfW, selfH);
   // self.backgroundColor = [UIColor greenColor];
    
    //self.scrollView = tableView;
}

-(void)didMoveToSuperview
{
    self.scrollView = (UIScrollView *)self.superview;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
