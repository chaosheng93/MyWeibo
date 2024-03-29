//
//  ZoomImageView.h
//  HWWeibo
//
//  Created by gj on 15/8/29.
//  Copyright (c) 2015年 www.huiwen.com 杭州汇文教育. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZoomImageView.h"

@class ZoomImageView;

@protocol ZoomImageViewDelegate <NSObject>
@optional
//图片将要放大
- (void)imageWillZoomIn:(ZoomImageView *)imageView;
//图片将要缩小
- (void)imageWillZoomOut:(ZoomImageView *)imageView;
//图片已经放大
//图片已经缩小

@end



@interface ZoomImageView : UIImageView<NSURLConnectionDataDelegate,UIAlertViewDelegate>{
    
    UIScrollView *_scrollView;
    UIImageView *_fullImageView;
    
}

@property(nonatomic,weak)id<ZoomImageViewDelegate> delegate;

@property(nonatomic,copy)NSString *fullImageUrlString;

#warning GIF图片处理
@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,assign)BOOL isGif;


@end
