//
//  WeiboCell.m
//  HWWeibo
//
//  Created by gj on 15/8/22.
//  Copyright (c) 2015年 www.huiwen.com 杭州汇文教育. All rights reserved.
//

#import "WeiboCell.h"
#import "UIImageView+WebCache.h"
#import "WeiboModel.h"
#import "Utils.h"
#import "WeiboView.h"

@implementation WeiboCell

//@property (weak, nonatomic) IBOutlet ThemeLabel *userNameLabel;
//@property (weak, nonatomic) IBOutlet ThemeLabel *commentCountLabel;
//@property (weak, nonatomic) IBOutlet ThemeLabel *repostCountLabel;
//@property (weak, nonatomic) IBOutlet ThemeLabel *createTimeLabel;
//@property (weak, nonatomic) IBOutlet ThemeLabel *sourceLabel;

- (void)awakeFromNib {
    
    self.weiboView = [[WeiboView alloc] initWithFrame:CGRectZero];
    //self.weiboView.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:self.weiboView];
    
    //背景颜色去掉
    self.backgroundColor = [UIColor clearColor];
    
    
    
    //设置主题颜色
    self.userNameLabel.colorName = @"Timeline_Name_color";
    self.commentCountLabel.colorName =@"Timeline_Name_color";
    self.repostCountLabel.colorName =@"Timeline_Name_color";
    self.createTimeLabel.colorName =@"Timeline_Time_color";
    self.sourceLabel.colorName =@"Timeline_Time_color";
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setLayoutFrame:(WeiboViewLaoutFrame *)layoutFrame{
    
    if (_layoutFrame != layoutFrame) {
        _layoutFrame = layoutFrame;
        [self setNeedsLayout];
    }

}


- (void)layoutSubviews{
        [super layoutSubviews];
    
    
    
        WeiboModel *model = self.layoutFrame.weiboModel;
    
        //头像
        NSString *urlStr = model.userModel.profile_image_url;
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
    
        //用户昵称
        self.userNameLabel.text = model.userModel.screen_name;
    
        //转发数
        self.repostCountLabel.text = [NSString stringWithFormat:@"转发:%@",model.repostsCount];
    
        //评论数
    
        self.commentCountLabel.text =[NSString stringWithFormat:@"评论:%@",model.commentsCount];
    
        //发布时间
        //封装工具类，为后面代码提供便利
        self.createTimeLabel.text = [Utils weiboDateString:model.createDate];
    
        //weiboView设置
        self.weiboView.layoutFrame = self.layoutFrame;
        self.weiboView.frame = self.layoutFrame.frame;
        //微博来源
        self.sourceLabel.text = model.source;
    
    
    
}





@end
