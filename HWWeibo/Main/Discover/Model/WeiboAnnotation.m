//
//  WeiboAnnotation.m
//  HWWeibo
//
//  Created by gj on 15/9/2.
//  Copyright (c) 2015年 www.huiwen.com 杭州汇文教育. All rights reserved.
//

#import "WeiboAnnotation.h"
#import <MapKit/MapKit.h>

@implementation WeiboAnnotation


- (void)setWeiboModel:(WeiboModel *)weiboModel{
    _weiboModel = weiboModel;
    NSDictionary *geo = weiboModel.geo;
    
    
    NSArray *coordinates = [geo objectForKey:@"coordinates"];
    if (coordinates.count >= 2) {
        
        NSString *longitude = coordinates[0];
        NSString *latitude = coordinates[1];
        
        _coordinate = CLLocationCoordinate2DMake([longitude floatValue], [latitude floatValue]);
    }
    
    
    
}

@end
