//
//  WeiboTableView.h
//  HWWeibo
//
//  Created by gj on 15/8/22.
//  Copyright (c) 2015年 www.huiwen.com 杭州汇文教育. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"

@interface WeiboTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

//布局对象
@property (nonatomic,strong) NSArray *layoutFrameArray;

@end
