//
//  WeiboTableView.m
//  HWWeibo
//
//  Created by gj on 15/8/22.
//  Copyright (c) 2015年 www.huiwen.com 杭州汇文教育. All rights reserved.
//

#import "WeiboTableView.h"
#import "WeiboCell.h"
#import "WeiboModel.h"
#include "WeiboViewLaoutFrame.h"
#import "UIView+UIViewController.h"

static NSString  *cellId = @"cellId";

@implementation WeiboTableView


- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self _createView];
    }
    
    return self;

}

- (void)awakeFromNib{
   // self.separatorStyle =  UITableViewCellSeparatorStyleNone;
    [self _createView];
}


- (void)_createView{
    
    self.delegate = self;
    self.dataSource = self;
    
    self.backgroundColor = [UIColor clearColor];
    
    //注册单元格
    UINib *nib = [UINib nibWithNibName:@"WeiboCell" bundle:nil];
    [self registerNib:nib forCellReuseIdentifier:cellId];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.layoutFrameArray.count;
}



- (NSInteger)numberOfSections{
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeiboCell *cell = [self dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    //设置数据
    cell.layoutFrame = self.layoutFrameArray[indexPath.row];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    //不能用如下方法获得cell
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:<#(NSIndexPath *)#>]
    
    //得到 weiboView的高度
    WeiboViewLaoutFrame *weiboLayoutFrame = self.layoutFrameArray[indexPath.row];
    
    CGRect frame = weiboLayoutFrame.frame;
    CGFloat height = frame.size.height;
    
    return height+85;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //微博详情控制器
    DetailViewController *vc = [[DetailViewController alloc] init];
    
    
    //把weiboModel传给微博详情控制器
    WeiboViewLaoutFrame *layoutFrame = self.layoutFrameArray[indexPath.row];
    WeiboModel *model = layoutFrame.weiboModel;
    vc.weiboModel = model;
    
    //事件响应者链
    [self.viewController.navigationController pushViewController:vc
                                                        animated:YES];
    

    
}




@end
