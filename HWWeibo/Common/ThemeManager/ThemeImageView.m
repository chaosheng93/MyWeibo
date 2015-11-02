//
//  ThemeImageView.m
//  HWWeibo
//
//  Created by gj on 15/8/21.
//  Copyright (c) 2015年 www.huiwen.com 杭州汇文教育. All rights reserved.
//

#import "ThemeImageView.h"
#import "ThemeManager.h"

@implementation ThemeImageView

- (void)dealloc{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNofication object:nil];
    
}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //添加通知观察者
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChangeAction:) name:kThemeDidChangeNofication object:nil];
        
    }
    return  self;
}
- (void)awakeFromNib{
    //添加通知观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChangeAction:) name:kThemeDidChangeNofication object:nil];
    
}


- (void)setImgName:(NSString *)imgName{
    
    if (![_imgName isEqualToString:imgName]) {
        _imgName = [imgName copy];
        [self loadImage];
    }
    
}


- (void)themeDidChangeAction:(NSNotification *)notification{
    //切换图片
    [self loadImage];
    
}


- (void)loadImage{
    ThemeManager *themeManager = [ThemeManager shareInstance];
    //通过管家获得图片
    UIImage *image = [themeManager getThemeImage:self.imgName];
    //拉伸点设置
    image = [image stretchableImageWithLeftCapWidth:self.leftCapWidth topCapHeight:self.topCapWidth];

    
    self.image = image;

    
}





@end
