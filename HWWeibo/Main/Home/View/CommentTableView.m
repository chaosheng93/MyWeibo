//
//  CommentTableView.m
//  HWWeibo
//
//  Created by gj on 15/8/28.
//  Copyright (c) 2015年 www.huiwen.com 杭州汇文教育. All rights reserved.
//

#import "CommentTableView.h"
#import "WeiboViewLaoutFrame.h"


@implementation CommentTableView

static NSString *cellId = @"cellId";

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    self =  [super initWithFrame:frame style:style];
    if (self) {
        [self _creatHeaderView];
        self.delegate = self;
        self.dataSource = self;
        UINib *nib = [UINib nibWithNibName:@"CommentCell" bundle:[NSBundle mainBundle]];
        [self registerNib:nib forCellReuseIdentifier:cellId];
    
    }
    return  self;
}

- (void)_creatHeaderView{
    //1.创建父视图
    _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
    _tableHeaderView.backgroundColor = [UIColor clearColor];
    
    //2.加载xib创建用户视图
    _userView = [[[NSBundle mainBundle] loadNibNamed:@"UserView" owner:self options:nil] lastObject];
    _userView.backgroundColor = [UIColor clearColor];
    _userView.width = kScreenWidth;
    _userView.backgroundColor = [UIColor grayColor];
    [_tableHeaderView addSubview:_userView];
    

    //3.创建微博视图
    _weiboView = [[WeiboView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    [_tableHeaderView addSubview:_weiboView];
    
    //self.tableHeaderView = _tableHeaderView;
    
}

- (void)setWeiboModel:(WeiboModel *)weiboModel{
    if (_weiboModel != weiboModel) {
        _weiboModel = weiboModel;
        
        //1.创建微博视图的布局对象
        WeiboViewLaoutFrame *layoutframe = [[WeiboViewLaoutFrame alloc] init];
        //isDetail 需要先赋值
        layoutframe.isDetail = YES;
        layoutframe.weiboModel = weiboModel;
        
        _weiboView.layoutFrame = layoutframe;
        _weiboView.frame = layoutframe.frame;
        
        _weiboView.top = _userView.bottom + 5;
        
        //2.用户视图
         _userView.weiboModel = weiboModel;
        
        //3.设置头视图
        _tableHeaderView.height = _weiboView.bottom+5;
        
        self.tableHeaderView = _tableHeaderView;
    }
    
}


#pragma mark -  TabelView 代理


//获取组的头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    //1.创建组视图
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 40)];
 
    //2.评论Label
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    countLabel.backgroundColor = [UIColor clearColor];
    countLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    countLabel.textColor = [UIColor blackColor];

    
    //3.评论数量
    NSNumber *total = [self.commentDic objectForKey:@"total_number"];
    int value = [total intValue];
    countLabel.text = [NSString stringWithFormat:@"评论:%d",value];
    [sectionHeaderView addSubview:countLabel];
    
    sectionHeaderView.backgroundColor = [UIColor grayColor];
    
    return sectionHeaderView;
}

//设置组的头视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

//设置单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentModel *model = self.commentDataArray[indexPath.row];
    //计算单元格的高度
    CGFloat height = [CommentCell getCommentHeight:model];
    
    return height;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.commentModel = self.commentDataArray[indexPath.row];

    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.commentDataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}








@end
