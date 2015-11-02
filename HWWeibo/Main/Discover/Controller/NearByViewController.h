//
//  NearByViewController.h
//  HWWeibo
//
//  Created by gj on 15/9/2.
//  Copyright (c) 2015年 www.huiwen.com 杭州汇文教育. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>



@interface NearByViewController : BaseViewController<CLLocationManagerDelegate,MKMapViewDelegate>{
    
    CLLocationManager *_locationManager;
    MKMapView *_mapView;
    
}

@end
