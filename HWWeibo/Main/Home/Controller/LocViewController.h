//
//  LocViewController.h
//  HWWeibo
//
//  Created by gj on 15/9/1.
//  Copyright (c) 2015年 www.huiwen.com 杭州汇文教育. All rights reserved.
//

#import "BaseViewController.h"
#import  <CoreLocation/CoreLocation.h>
#import "PoiModel.h"
//附近商圈


@interface LocViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
{
    UITableView *_tableView;
    CLLocationManager *_locationManager;
}
@property (nonatomic ,strong) NSArray *dataList;

@end
