//
//  LeftViewController.h
//  HWWeibo
//
//  Created by gj on 15/8/22.
//  Copyright (c) 2015年 www.huiwen.com 杭州汇文教育. All rights reserved.
//

#import "BaseViewController.h"

@interface LeftViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    NSArray *_sectionTitles;
    NSArray *_rowTitles;
}

@end
