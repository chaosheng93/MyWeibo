//
//  LeftViewController.m
//  HWWeibo
//
//  Created by gj on 15/8/22.
//  Copyright (c) 2015年 www.huiwen.com 杭州汇文教育. All rights reserved.
//

#import "LeftViewController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "ThemeLabel.h"

@interface LeftViewController ()

@end

@implementation LeftViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
     
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 1.初始化数据
    [self _loadData];
    
    // 2.初始化子视图
    [self _initViews];
    
    [self setBgImage];
    
}

// 2.初始化子视图
- (void)_initViews
{
    // 创建表视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(-5, 0, 165, kScreenHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = nil;
    _tableView.backgroundView = nil;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    // 设置内填充
    _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    [self.view addSubview:_tableView];
}

// 1.初始化数据
- (void)_loadData
{
    _sectionTitles = @[@"界面切换效果",@"图片浏览模式"];
    
    _rowTitles = @[@[@"无",
                     @"偏移",
                     @"偏移&缩放",
                     @"旋转",
                     @"视差"],
                   @[@"小图",
                     @"大图"]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_rowTitles[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"leftCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
   
    cell.textLabel.text = _rowTitles[indexPath.section][indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    
    ThemeLabel *sectionLabel = [[ThemeLabel alloc] initWithFrame:CGRectMake(0, 0, 160, 50)];
    sectionLabel.colorName = @"More_Item_Text_color";
    sectionLabel.backgroundColor = [UIColor clearColor];
    sectionLabel.font = [UIFont boldSystemFontOfSize:18];
    sectionLabel.text = [NSString stringWithFormat:@"  %@", _sectionTitles[section]];
    return sectionLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}


@end
