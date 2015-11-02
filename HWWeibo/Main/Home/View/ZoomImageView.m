//
//  ZoomImageView.m
//  HWWeibo
//
//  Created by gj on 15/8/29.
//  Copyright (c) 2015年 www.huiwen.com 杭州汇文教育. All rights reserved.
//

#import "ZoomImageView.h"
#import "DDProgressView.h"
#import "MBProgressHUD.h"
#import <ImageIO/ImageIO.h>
#import "UIImage+GIF.h"

@implementation ZoomImageView{
    double _length;//总长度
    NSMutableData *_data;//下载的数据
    DDProgressView *_progressView;
    NSURLConnection *_connection;
}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initTap];
        [self _createGifIcon];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _initTap];
        [self _createGifIcon];
    }
    return  self;
    
    
}
- (instancetype)initWithImage:(UIImage *)image{
    self = [super initWithImage:image];
    if (self) {
        [self _initTap];
        [self _createGifIcon];
    }
    return  self;
}
#warning -----gif处理
- (void)_createGifIcon{
    
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _iconImageView.hidden = YES;
    _iconImageView.image = [UIImage imageNamed:@"timeline_gif.png"];
    [self addSubview:_iconImageView];
    
    
    
    
}




- (void)_initTap{
    //01 打开交互
    self.userInteractionEnabled = YES;
    
    //02 创建单击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomIn)];
    
    [self addGestureRecognizer:tap];
    
    //03 设置显示 模式,等比例
    self.contentMode = UIViewContentModeScaleAspectFit;
    
    
    
}

- (void)zoomIn{
    
    //调用代理方法
    if ([self.delegate respondsToSelector:@selector(imageWillZoomIn:)]) {
        
        [self.delegate imageWillZoomIn:self];

    }
    
    
    
    /**
        01 隐藏原图
     */
    self.hidden = YES;
    
    //02 创建大图浏览_scrollView
    [self _createView];
    
    //03 计算_fullImageView的Frame
    //计算出 小图 self 相对于 window的坐标
    CGRect frame = [self convertRect:self.bounds  toView:self.window];
    _fullImageView.frame = frame;
    
    //04 放大图片动画
    [UIView animateWithDuration:0.3 animations:^{
       
        _fullImageView.frame = _scrollView.bounds;
        
    } completion:^(BOOL finished) {
        _scrollView.backgroundColor = [UIColor blackColor];
        
        
    }];
    
    //05 请求网络 下载大图
    if (self.fullImageUrlString.length > 0) {
        
        NSURL *url = [NSURL URLWithString:self.fullImageUrlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
        
        
        _connection =  [NSURLConnection connectionWithRequest:request delegate:self];
        
    }

}

- (void)zoomOut{
    
    //调用代理方法
    if ([self.delegate respondsToSelector:@selector(imageWillZoomOut:)]) {
        
        [self.delegate imageWillZoomOut:self];
        
    }
    
    
    
    
    //取消网络下载
    [_connection cancel];
    
    //缩小动画效果
     self.hidden = NO;
    [UIView animateWithDuration:0.3
                     animations:^{
                          _scrollView.backgroundColor = [UIColor clearColor];
                         CGRect frame = [self convertRect:self.bounds  toView:self.window];
                         _fullImageView.frame = frame;
                         
                         
                     } completion:^(BOOL finished) {
                         
                         [_scrollView removeFromSuperview];
                         _scrollView = nil;
                         _fullImageView = nil;
                         _progressView = nil;
                         _data = nil;
                     }];
    
    
}



- (void)_createView{
    if (_scrollView == nil) {

        //1 创建scrollView
        _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self.window addSubview:_scrollView];
        
        //2 创建大图图片
        _fullImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _fullImageView.contentMode = UIViewContentModeScaleAspectFit;
        _fullImageView.image = self.image;
        [_scrollView addSubview:_fullImageView];
        
        
        //3 添加手势
        //01 单击
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomOut)];
        
        [_scrollView addGestureRecognizer:tap];
        
#warning ----长按手势添加保存相片
        //02 长按 保存
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(savePhoto:)];
       // longPress.minimumPressDuration = 1.5;
        [_scrollView addGestureRecognizer:longPress];
        
        
        
    
        //4 添加进度条
        _progressView = [[DDProgressView alloc] init];
        _progressView.frame = CGRectMake(10, kScreenHeight/2, kScreenWidth-20, 50);
        _progressView.outerColor = [UIColor yellowColor];
        _progressView.innerColor = [UIColor lightGrayColor];
        _progressView.emptyColor = [UIColor darkGrayColor];
        _progressView.hidden = YES;
        
        [_scrollView addSubview:_progressView];
    
    }

}
#pragma mark - 长按图片处理
- (void)savePhoto:(UILongPressGestureRecognizer *)longPress{
    
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
        //弹出提示框
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否保存图片" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alert show];
        
    }
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        UIImage *img = [UIImage imageWithData:_data];
        //1.提示保存
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
        hud.labelText = @"正在保存";
        hud.dimBackground = YES;
        
        //2.将大图图片保存到相册
        //  - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
        UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)(hud));
        
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    //提示保存成功
    MBProgressHUD *hud = (__bridge MBProgressHUD *)(contextInfo);
    
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    //显示模式改为：自定义视图模式
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"保存成功";
    
    //延迟隐藏
    [hud hide:YES afterDelay:1.5];
}

#pragma -mark  网络代理
//服务器对请求的反馈
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{

    //响应 ，length
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    //01 取得响应头信息
    NSDictionary *allHeaderFields = [httpResponse allHeaderFields];
    
    //02 从响应头获取长度
    NSString *size = [allHeaderFields objectForKey:@"Content-Length"];
    
    _length = [size doubleValue];
    
    _data = [[NSMutableData alloc] init];
    _progressView.hidden = NO;
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    //
    [_data appendData:data];
    
    CGFloat progress = _data.length/_length;
    _progressView.progress = progress;
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    _progressView.hidden = YES;

    
    UIImage *image = [UIImage imageWithData:_data];
    _fullImageView.image = image;
    
    //处理imageView尺寸
    // 图片的长/图片的宽 ==  ImageView.长（？）/屏幕宽
    [UIView animateWithDuration:0.5 animations:^{
        
            CGFloat length = image.size.height/image.size.width * kScreenWidth;
            if (length < kScreenHeight) {
                _fullImageView.top = (kScreenHeight-length)/2;
            }
            _fullImageView.height = length;
            _scrollView.contentSize = CGSizeMake(kScreenWidth, length);

        
    } completion:^(BOOL finished) {
        _scrollView.backgroundColor = [UIColor blackColor];
        
    }];
    
    if (self.isGif) {
        [self gifImageShow];
    }
    
    


}
- (void)gifImageShow{
    //1.-----------------webView播放---------------------
//            UIWebView *webView = [[UIWebView alloc] initWithFrame:_scrollView.bounds];
//            webView.userInteractionEnabled = NO;
//            webView.backgroundColor = [UIColor clearColor];
//            webView.scalesPageToFit = YES;
//    
//            //使用webView加载图片数据
//            [webView loadData:_data MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
//            [_scrollView addSubview:webView];
    
    
    //2. ---------使用ImageIO 提取GIF中所有帧的图片进行播放---------------
    //#import <ImageIO/ImageIO.h>
    
//    
//    //1>创建图片源
//    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)(_data), NULL);
//    
//    //2>获取图片源中图片的个数
//    size_t count = CGImageSourceGetCount(source);
//    
//    NSMutableArray *images = [NSMutableArray array];
//    
//    NSTimeInterval duration = 0;
//    
//    for (size_t i=0; i<count; i++) {
//        
//        //3>取得每一张图片
//        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
//        UIImage *uiImg = [UIImage imageWithCGImage:image];
//        [images addObject:uiImg];
//        
//        //0.1 是一帧播放的时间，累加每一帧的时间
//        duration += 0.1;
//    }
//    
//    //>4-1.或者将所有帧的图片集成到一个动画UIImage对象中
//    UIImage *imgs = [UIImage animatedImageWithImages:images duration:duration];
//    _fullImageView.image = imgs;
//    
//    //        //>4-2.或者将播放的图片组交给_fullImageView播放
//    //        _fullImageView.animationImages = images;
//    //        _fullImageView.animationDuration = duration;
//    //        [_fullImageView startAnimating];
    
    
    //3 -------------SDWebImage 封装的GIF播放------------------
    //#import "UIImage+GIF.h"
    _fullImageView.image = [UIImage sd_animatedGIFWithData:_data];

    
}



@end
