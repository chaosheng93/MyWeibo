//
//  WeiboView.h
//  HWWeibo
//
//  Created by gj on 15/8/24.
//  Copyright (c) 2015年 www.huiwen.com 杭州汇文教育. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeImageView.h"
#import "WXLabel.h"
#import "ZoomImageView.h"


@class WeiboViewLaoutFrame;

@interface WeiboView : UIView<WXLabelDelegate>

@property (nonatomic,strong) WXLabel *textLabel;//微博文字
@property (nonatomic,strong) WXLabel *sourceLabel;//原微博文字
@property (nonatomic,strong) ZoomImageView *imgView;//微博图片
@property (nonatomic,strong) ThemeImageView *bgImgView;//原微博背景图片

@property (nonatomic,strong) WeiboViewLaoutFrame *layoutFrame;

@end
