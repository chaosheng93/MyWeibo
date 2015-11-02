//
//  CommentTableView.h
//  HWWeibo
//
//  Created by gj on 15/8/28.
//  Copyright (c) 2015年 www.huiwen.com 杭州汇文教育. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboView.h"
#import "WeiboModel.h"
#import "UserView.h"
#import "CommentCell.h"


@interface CommentTableView : UITableView<UITableViewDataSource,UITableViewDelegate>
{
    //用户视图
    UserView *_userView;
    //微博视图
    WeiboView *_weiboView;
    //头视图
    UIView *_tableHeaderView;
}
@property(nonatomic,strong)NSArray *commentDataArray;//评论列表
@property(nonatomic,strong)WeiboModel *weiboModel;//微博model
@property(nonatomic,strong)NSDictionary *commentDic;//评论字典



@end

