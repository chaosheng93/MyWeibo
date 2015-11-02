//
//  ThemeButton.m
//  HWWeibo
//
//  Created by gj on 15/8/21.
//  Copyright (c) 2015年 www.huiwen.com 杭州汇文教育. All rights reserved.
//

#import "ThemeButton.h"
#import "ThemeManager.h"

@implementation ThemeButton

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


- (void)themeDidChangeAction:(NSNotification *)notification{
    //切换图片
    [self loadImage];

}

- (void)setNormalImgName:(NSString *)normalImgName{
    if (![_normalImgName isEqualToString:normalImgName]) {
        _normalImgName = [normalImgName copy];
        [self loadImage];
    }
}

- (void)setHighlightImgName:(NSString *)highlightImgName{
    if (![_highlightImgName isEqualToString:highlightImgName]) {
         _highlightImgName = [highlightImgName copy];
        [self loadImage];
    }
}


- (void)setNormalBgImgName:(NSString *)normalBgImgName{
    if (![_normalBgImgName isEqualToString:normalBgImgName]) {
        _normalBgImgName = [normalBgImgName copy];
        [self loadImage];
    }
}

- (void)setHighlightBgImgName:(NSString *)highlightBgImgName{
    if (![_highlightBgImgName isEqualToString:highlightBgImgName]) {
        _highlightBgImgName = [highlightBgImgName copy];
        [self loadImage];
    }
    
    
}

- (void)loadImage{
    
    ThemeManager *themeManager = [ThemeManager shareInstance];
    //通过管家获得图片
    UIImage *normalImage = [themeManager getThemeImage:self.normalImgName];
    UIImage *highlightImage = [themeManager getThemeImage:self.highlightImgName ];
    
    if (normalImage != nil) {
        [self setImage:normalImage forState:UIControlStateNormal];
    }
    if (highlightImage != nil) {
        [self setImage:highlightImage forState:UIControlStateHighlighted];
    }
    
    //背景图片设置
    UIImage *normalBgImage = [themeManager getThemeImage:self.normalBgImgName];
    UIImage *highlightBgImage = [themeManager getThemeImage:self.highlightBgImgName];
    
    if (normalBgImage != nil) {
        [self setBackgroundImage:normalImage forState:UIControlStateNormal];
    
    }
    if (highlightBgImage != nil) {
        [self setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    }
    
}

@end
