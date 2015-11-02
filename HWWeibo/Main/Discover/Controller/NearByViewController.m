//
//  NearByViewController.m
//  HWWeibo
//
//  Created by gj on 15/9/2.
//  Copyright (c) 2015年 www.huiwen.com 杭州汇文教育. All rights reserved.
//

#import "NearByViewController.h"
#import "DataService.h"
#import "WeiboAnnotation.h"
#import "WeiboAnnotationView.h"
#import "DetailViewController.h"

//http://open.weibo.com/wiki/2/place/nearby_timeline

@interface NearByViewController ()

@end

@implementation NearByViewController


/**
 *  显示地图标注 步骤
 1、定义遵循（MKAnnotation协议）Annotation类 （model）
 2、创建Annotation对象，把对象添加到MapView上
 3、实现MapView的协议方法，创建标注视图
 */

//tableView   _dataArray  cellForRowAtindexPath


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"附近的微博";
    [self _createViews];
    [self _location];
    
  
}


#pragma mark - 地图 

- (void)_createViews{
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    //显示用户位置
    _mapView.showsUserLocation = YES;
    //地图显示类型 ：  卫星，标准， 混合
    _mapView.mapType = MKMapTypeStandard;
    //代理
    _mapView.delegate = self;
    
    [self.view addSubview:_mapView];
    
    
    //测试
    //创建annotation 对象(model)
//    WeiboAnnotation *annotation = [[WeiboAnnotation alloc] init];
//    annotation.title = @"汇文教育";
//    CLLocationCoordinate2D coordinate = {30.1742,120.2119};
//    [annotation setCoordinate:coordinate];
//    [_mapView addAnnotation:annotation];
    
}



//一 大头针  实现协议方法，返回标注视图
//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
//    //MKUserLocation  用户当前位置的类
//    
//
//    if ([annotation isKindOfClass:[MKUserLocation class]]) {
//        return nil;
//    }
//    
//    
//    //复用池，得到 大头针标注视图
//    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"view"];
//    
//    if (pinView == nil) {
//        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"view"];
//        
//        //1  设置大头针颜色
//        pinView.pinColor = MKPinAnnotationColorGreen;
//        
//        //2  从天而降动画
//        pinView.animatesDrop = YES;
//        
//        //3 设置显示标题
//        pinView.canShowCallout = YES;
//        //添加辅助视图
//        pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//        
//        
//    }
//    
//    return pinView;
//    
//
//}

// 二 项目中 微博标注视图（自定义） 创建
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    //得到标注视图
    WeiboAnnotationView *annotationView = (WeiboAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"view"];
    
    if (annotationView == nil) {
        annotationView = [[WeiboAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"view"];
    }
    
    annotationView.annotation = annotation;
    return annotationView;
    
    
}


//选中标注视图的协议方法
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    NSLog(@"选中");
   // return;
    
    if (![view.annotation isKindOfClass:[WeiboAnnotation class]]) {
        return;
    }

    DetailViewController *detailVC = [[DetailViewController alloc] init];
    
    WeiboAnnotation *annoation = (WeiboAnnotation *)view.annotation;
    WeiboModel *weiboModel = annoation.weiboModel;
    
    detailVC.weiboModel = weiboModel;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}


#pragma mark - 定位
- (void)_location{
    _locationManager = [[CLLocationManager alloc] init];
    
    if (kVersion > 8.0) {
        [_locationManager requestWhenInUseAuthorization];
    }
    _locationManager.desiredAccuracy =  kCLLocationAccuracyBest;
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    
}

//位置更新代理
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    //1 停止定位
    [_locationManager stopUpdatingLocation];
  
    //2 请求数据
    NSString *lon = [NSString stringWithFormat:@"%f",coordinate.longitude];
    NSString *lat = [NSString stringWithFormat:@"%f",coordinate.latitude];
    [self _loadNearByData:lon lat:lat];
    
    
    //3 设置地图显示区域

    CLLocationCoordinate2D center = coordinate;
    //数值越小,显示范围越小
    MKCoordinateSpan span = {0.1,0.1};
    MKCoordinateRegion region = {center,span};
    [_mapView setRegion:region];

}

//获取附近微博
- (void)_loadNearByData:(NSString *)lon lat:(NSString *)lat{
    
    
    //修改 AFNetWorking 支持 text/html  AFURLResponseSerialization.m中
    //self.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",nil];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:lon forKey:@"long"];
    [params setObject:lat forKey:@"lat"];
    

    [DataService requestAFUrl:nearby_timeline httpMethod:@"GET" params:params data:nil block:^(id result) {
        
        NSArray *statuses = [result objectForKey:@"statuses"];
        
        NSMutableArray *annotationArray = [[ NSMutableArray alloc] initWithCapacity:statuses.count];
        
        
        for (NSDictionary *dataDic in statuses) {
            
            WeiboModel *model = [[WeiboModel alloc] initWithDataDic:dataDic];
            
            WeiboAnnotation *annotation = [[WeiboAnnotation alloc] init];
            annotation.weiboModel = model;
            
            [annotationArray addObject:annotation];
            
            
        }
        
        [_mapView addAnnotations:annotationArray];
        

    
    }];

}






@end
