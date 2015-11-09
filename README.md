# MYRefresh
tableView的category-上拉加载，下拉刷新，可以设置刷新，加载过程各个状态的标题
/*
 使用说明：
 //开启下拉刷新
 [tableView addRefreshView]
 //关闭下拉刷新
 [tableView stopRefreshDisplayWithStatus:DataRefreshStatusSucceed]
 
 开启上拉加载
 [tableView addDownloadView]
 关闭上拉加载
 [tableView stopDownloadDisplayWithStatus:DataLoadStatusSucceed]
 
    更改下拉刷新，上拉加载 标题内容的时候，必须先调用add方法，否则更改无效
 
 */
