//
//  WeiboCell.h
//  HWWeibo
//
//  Created by gj on 15/8/22.
//  Copyright (c) 2015年 www.huiwen.com 杭州汇文教育. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"
#import "WeiboView.h"
#import "WeiboViewLaoutFrame.h"
#import "ThemeLabel.h"

@interface WeiboCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet ThemeLabel *userNameLabel;
@property (weak, nonatomic) IBOutlet ThemeLabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet ThemeLabel *repostCountLabel;
@property (weak, nonatomic) IBOutlet ThemeLabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet ThemeLabel *sourceLabel;



@property (nonatomic,strong) WeiboView *weiboView;
@property (nonatomic,strong) WeiboViewLaoutFrame *layoutFrame;
//@property (nonatomic,strong) WeiboModel *model;

@end
