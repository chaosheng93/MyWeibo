//
//  WeiboView.m
//  HWWeibo
//
//  Created by gj on 15/8/24.
//  Copyright (c) 2015年 www.huiwen.com 杭州汇文教育. All rights reserved.
//

#import "WeiboView.h"
#import "WeiboViewLaoutFrame.h"
#import "UIImageView+WebCache.h"
#import "ThemeManager.h"

@implementation WeiboView

- (void)dealloc{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _createSubViews];
    }
    
    return  self;
}


- (void)awakeFromNib{
    [self _createSubViews];
    
}
- (void)_createSubViews{
    //1 微博内容
    _textLabel = [[WXLabel alloc] initWithFrame:CGRectZero];
    _textLabel.linespace = 5;
  //  _textLabel.font = [UIFont systemFontOfSize:15];
    _textLabel.wxLabelDelegate = self;
    [self addSubview:_textLabel];
    

    //2 原微博内容
    _sourceLabel = [[WXLabel alloc] initWithFrame:CGRectZero];
    _sourceLabel.linespace = 5;
    
    
    //_sourceLabel.font = [UIFont systemFontOfSize:14];
    _sourceLabel.wxLabelDelegate = self;
    [self addSubview:_sourceLabel];
    //主题颜色
    _textLabel.textColor = [[ThemeManager shareInstance] getThemeColor:@"Timeline_Content_color"];
    _sourceLabel.textColor = [[ThemeManager shareInstance] getThemeColor:@"Timeline_Content_color"];
    
    
    //3 图片
    _imgView = [[ZoomImageView alloc] initWithFrame:CGRectZero];
    _imgView.contentMode= UIViewContentModeScaleAspectFit;
    [self addSubview:_imgView];
    
    //4 原微博背景图片
    
    _bgImgView = [[ThemeImageView alloc] initWithFrame:CGRectZero];
   // _bgImgView.backgroundColor = [UIColor redColor];
    
    //拉伸点设置
    _bgImgView.leftCapWidth = 25;
    _bgImgView.topCapWidth = 25;
    
    _bgImgView.imgName = @"timeline_rt_border_9.png";
    
    //[self addSubview:_bgImgView];
    [self insertSubview:_bgImgView atIndex:0];
    
    
    
    //5 监听主题切换通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(themeChangeAction:)
                                                 name:kThemeDidChangeNofication object:nil];
    
}


- (void)setLayoutFrame:(WeiboViewLaoutFrame *)layoutFrame{
    if (_layoutFrame != layoutFrame) {
        _layoutFrame = layoutFrame;
        [self setNeedsLayout];
    }
    
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    _textLabel.font =   [UIFont systemFontOfSize: FontSize_Weibo(_layoutFrame.isDetail)] ;
    _sourceLabel.font =  [UIFont systemFontOfSize: FontSize_ReWeibo(_layoutFrame.isDetail)] ;

    
    

    WeiboModel *weiboModel = self.layoutFrame.weiboModel;
    
    //1 设置微博文字
    _textLabel.frame = self.layoutFrame.textFrame;
    _textLabel.text = weiboModel.text;
    
    //2  微博是否是转发的
    //有原微博
    if (weiboModel.reWeiboModel != nil) {
        self.bgImgView.hidden = NO;
        self.sourceLabel.hidden = NO;
        //原微博背景图片frame
        self.bgImgView.frame = self.layoutFrame.bgImgFrame;
        
        //原微博内容及frame
        self.sourceLabel.text = weiboModel.reWeiboModel.text;
        self.sourceLabel.frame = self.layoutFrame.srTextFrame;
        
        NSString *imgUrl = weiboModel.reWeiboModel.thumbnailImage;
        NSString *fullImgUrl = weiboModel.reWeiboModel.originalImage;
        
        if (imgUrl != nil) {
            self.imgView.hidden = NO;
            self.imgView.frame = self.layoutFrame.imgFrame;
            
            [self.imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
            
            self.imgView.fullImageUrlString = fullImgUrl;
            
        }else{
            
            self.imgView.hidden = YES;
        }
        
    }else{//无原微博
        self.bgImgView.hidden = YES;
        self.sourceLabel.hidden = YES;
        NSString *imgUrl = weiboModel.thumbnailImage;
        //是否有图片
        if (imgUrl == nil) {
            self.imgView.hidden = YES;
        }else{
            self.imgView.hidden = NO;
            self.imgView.frame = self.layoutFrame.imgFrame;
            
            [self.imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
            
            //微博大图的链接
            self.imgView.fullImageUrlString = weiboModel.originalImage;
            
        }
        
    }

    
#warning 判断图片是否是GIF
    if (self.imgView.hidden == NO) {
        UIImageView *iconView = self.imgView.iconImageView;
        iconView.frame = CGRectMake(_imgView.width-24, _imgView.height-15, 24, 15);
        NSString *extension = [weiboModel.thumbnailImage pathExtension];
        if ([extension isEqualToString:@"gif"]) {
            iconView.hidden = NO;
            self.imgView.isGif = YES;
            
        } else {
            iconView.hidden = YES;
            self.imgView.isGif = NO;
            
        }
    }
   
    
}



#pragma  mark - WXLabel delegate
//链接被点击之后调用
- (void)toucheEndWXLabel:(WXLabel *)wxLabel withContext:(NSString *)context{
    
    NSLog(@"%@",context);
}

//返回处理链接的表达式
 - (NSString *)contentsOfRegexStringWithWXLabel:(WXLabel *)wxLabel
 {
 //需要添加链接字符串的正则表达式：@用户、http://、#话题#
        NSString *regex1 = @"@\\w+";

        NSString *regex2 = @"http(s)?://([A-Za-z0-9._-]+(/)?)*";
        NSString *regex3 = @"#\\w+#";
        NSString *regex = [NSString stringWithFormat:@"(%@)|(%@)|(%@)",regex1,regex2,regex3];
        return regex;
 }

//设置当前链接文本的颜色
- (UIColor *)linkColorWithWXLabel:(WXLabel *)wxLabel{
    //return  [UIColor redColor];
    
    return  [[ThemeManager shareInstance] getThemeColor:@"Link_color"];
    
    
}
//链接点击高亮颜色
- (UIColor *)passColorWithWXLabel:(WXLabel *)wxLabel{
    return  [UIColor blueColor];
}
 


- (void)themeChangeAction:(NSNotification *)notification{
    _textLabel.textColor = [[ThemeManager shareInstance] getThemeColor:@"Timeline_Content_color"];
    _sourceLabel.textColor = [[ThemeManager shareInstance] getThemeColor:@"Timeline_Content_color"];
    
    //重新绘制 DrawRect
    //[_textLabel setNeedsDisplay];
    //[_sourceLabel setNeedsDisplay];
}



@end
