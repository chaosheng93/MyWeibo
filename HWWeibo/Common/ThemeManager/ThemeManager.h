//
//  ThemeManager.h
//  HWWeibo
//
//  Created by gj on 15/8/21.
//  Copyright (c) 2015年 www.huiwen.com 杭州汇文教育. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kThemeDidChangeNofication @"kThemeDidChangeNofication"
#define kThemeName @"kThemeName"



@interface ThemeManager : NSObject

//当前主题的名字 ，根据名字可以在theme.plist找到当前主题的路径
@property(nonatomic,copy) NSString *themeName;
@property(nonatomic,strong) NSDictionary *themeConfig;
@property(nonatomic,strong) NSDictionary *colorConfig;



+ (ThemeManager *)shareInstance;


/**
 *  方法说明 ：获取当前主题下的对应的图片
 *
 *  @param imageName : 图片名字（不是路径），--》注释 路径应该是 主题包路径+图片名字
 *
 *  @return 图片
 */
- (UIImage *)getThemeImage:(NSString *)imageName;



- (UIColor *)getThemeColor:(NSString *)colorName;


@end
