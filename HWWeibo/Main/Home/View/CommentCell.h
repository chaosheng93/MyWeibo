//
//  CommentCell.h
//  HWWeibo
//
//  Created by gj on 15/8/28.
//  Copyright (c) 2015年 www.huiwen.com 杭州汇文教育. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXLabel.h"
#import "CommentModel.h"
#import "UIImageView+WebCache.h"


@interface CommentCell : UITableViewCell<WXLabelDelegate>{
    
    __weak IBOutlet UILabel *_nameLabel;
    __weak IBOutlet UIImageView *_imgView;
    WXLabel *_commentTextLabel;
}




@property(nonatomic,retain)CommentModel *commentModel;

//计算评论单元格的高度
+ (float)getCommentHeight:(CommentModel *)commentModel;



@end
