//
//  Common.h
//  HWWeibo
//
//  Created by gj on 15/8/19.
//  Copyright (c) 2015年 www.huiwen.com 杭州汇文教育. All rights reserved.
//

#ifndef HWWeibo_Common_h
#define HWWeibo_Common_h

//系统版本
#define   kVersion   [[UIDevice currentDevice].systemVersion floatValue]
//屏幕的宽、高
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

//新浪微博的key
#define kAppKey             @"108653288"
#define kAppSecret          @"4b44cf4b051bc73a7638b755f4edbc69"
#define kAppRedirectURI     @"https://api.weibo.com/oauth2/default.html"


#define unread_count @"remind/unread_count.json"  //未读消息
#define home_timeline @"statuses/home_timeline.json"  //微博列表
#define comments  @"comments/show.json"   //评论列表
#define send_update @"statuses/update.json"  //发微博(不带图片)
#define send_upload @"statuses/upload.json"  //发微博(带图片)
#define geo_to_address @"location/geo/geo_to_address.json"  //查询坐标对应的位置
#define nearby_pois @"place/nearby/pois.json" // 附近商圈
#define nearby_timeline  @"place/nearby_timeline.json" //附近动态


//微博字体
#define FontSize_Weibo(isDetail) isDetail?16:15
#define FontSize_ReWeibo(isDetail) isDetail?15:14


#endif
