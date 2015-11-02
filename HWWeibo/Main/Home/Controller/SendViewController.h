//
//  SendViewController.h
//  HWWeibo
//
//  Created by gj on 15/8/30.
//  Copyright (c) 2015年 www.huiwen.com 杭州汇文教育. All rights reserved.
//

#import "BaseViewController.h"
#import "ZoomImageView.h"
#import <CoreLocation/CoreLocation.h>
#import "FaceScrollView.h"


@interface SendViewController : BaseViewController<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,ZoomImageViewDelegate,CLLocationManagerDelegate,FaceViewDelegate>{
    
    //1 文本编辑栏
    UITextView *_textView;
    
    
    //2 工具栏
    UIView *_editorBar;
    
    //3 显示缩略图
    ZoomImageView *_zoomImageView;
    
    
    //4 位置管理器 
    
    CLLocationManager *_locationManager;
    UILabel *_locationLabel;
    
    //5 表情面板
    
    FaceScrollView *_faceViewPanel;
    
}

@end
