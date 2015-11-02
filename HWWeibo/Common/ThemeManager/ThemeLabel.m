//
//  ThemeLabel.m
//  HWWeibo
//
//  Created by gj on 15/8/21.
//  Copyright (c) 2015年 www.huiwen.com 杭州汇文教育. All rights reserved.
//

#import "ThemeLabel.h"
#import "ThemeManager.h"

@implementation ThemeLabel

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNofication object:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadColor) name:kThemeDidChangeNofication object:nil];
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadColor) name:kThemeDidChangeNofication object:nil];
}


- (void)setColorName:(NSString *)colorName {
    if (_colorName != colorName) {
        _colorName = [colorName copy];
        
        [self loadColor];
    }
}

- (void)loadColor {
    
    UIColor *fontColor = [[ThemeManager shareInstance] getThemeColor:self.colorName];
    
    self.textColor = fontColor;
}






@end
