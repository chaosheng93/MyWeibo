//
//  ThemeButton.h
//  HWWeibo
//
//  Created by gj on 15/8/21.
//  Copyright (c) 2015年 www.huiwen.com 杭州汇文教育. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeButton : UIButton

//normal状态下的图片名字 
@property (nonatomic,copy)NSString *normalImgName;

//highlight  状态下的图片名字
@property (nonatomic,copy)NSString *highlightImgName;

//normal 状态背景图片
@property (nonatomic,copy)NSString *normalBgImgName;

//highlight  状态下的背景图片名字
@property (nonatomic,copy)NSString *highlightBgImgName;



@end
