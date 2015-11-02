//
//  WeiboAnnotationView.h
//  HWWeibo
//
//  Created by gj on 15/9/2.
//  Copyright (c) 2015年 www.huiwen.com 杭州汇文教育. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "WeiboAnnotation.h"
#import "WeiboModel.h"

//自定义 AnnotationView
@interface WeiboAnnotationView : MKAnnotationView{
    UIImageView *_userHeadImageView;//头像图片
    UILabel *_textLabel;//微博内容
}



@end
