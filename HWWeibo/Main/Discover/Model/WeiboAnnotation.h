//
//  WeiboAnnotation.h
//  HWWeibo
//
//  Created by gj on 15/9/2.
//  Copyright (c) 2015年 www.huiwen.com 杭州汇文教育. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "WeiboModel.h"


@interface WeiboAnnotation : NSObject<MKAnnotation>


@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

//坐标从 weiboModel中获取
@property (nonatomic,strong) WeiboModel *weiboModel;






@end
