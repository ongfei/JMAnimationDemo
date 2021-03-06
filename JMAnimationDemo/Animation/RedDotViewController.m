//
//  RedDotViewController.m
//  JMAnimationDemo
//
//  Created by jm on 16/3/16.
//  Copyright © 2016年 JM. All rights reserved.
//

#import "RedDotViewController.h"
#import "RedDotView.h"
#import "RedDotCell.h"
#import "RedDotCellModel.h"

@interface RedDotViewController() <UITableViewDelegate, UITableViewDataSource>

@end

@implementation RedDotViewController {
    UITableView *_tableView;
    NSArray *_array;
    RedDotView *_redDotView;
    RedDotView *_redDotView2;
}

-(void)loadView {
    [super loadView];
    _redDotView = [[RedDotView alloc] initWithMaxDistance:75 bubbleColor:[self colorFromRGB:0x99CCCC]];
    _redDotView2 = [[RedDotView alloc] initWithMaxDistance:150 bubbleColor:[self colorFromRGB:0x99CCCC]];
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _tableView.rowHeight = 55;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[RedDotCell class] forCellReuseIdentifier:@"cell"];
    
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    rightLabel.text = @"菜单";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightLabel];
    
    __weak typeof(self) weakSelf = self;
    [_redDotView attach:rightLabel withSeparateBlock:^BOOL(UIView *view) {
        weakSelf.navigationItem.rightBarButtonItem = nil;
        return YES;
    }];
    
    [self.view addSubview:_tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < 100; i ++) {
        RedDotCellModel *model = [[RedDotCellModel alloc] init];
        model.name = @"name";
        model.message = @"这是一条信息";
        model.time = @"19:00";
        model.messageCount = @99;
        model.avatar = [UIImage imageNamed:@"avatar.jpg"];
        [array addObject:model];
    }
    _array = array.copy;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RedDotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    RedDotCellModel *model = _array[indexPath.row];
    cell.cellModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [_redDotView attach:cell.avatarView withSeparateBlock:^BOOL(UIView *view) {
        return NO;
    }];
    
    [_redDotView attach:cell.nameLabel withSeparateBlock:nil];
    
    [_redDotView attach:cell.messageLabel withSeparateBlock:^BOOL(UIView *view) {
        model.message = nil;
        return YES;
    }];
    
    [_redDotView attach:cell.timeLabel withSeparateBlock:^BOOL(UIView *view) {
        model.time = nil;
        return YES;
    }];
    
    [_redDotView attach:cell.redDotLabel withSeparateBlock:^BOOL(UIView *view) {
        model.messageCount = nil;
        return YES;
    }];
    
    [_redDotView2 attach:cell withSeparateBlock:^BOOL(UIView *view) {
        model.contentViewHidden = YES;
        return YES;
    }];
    return cell;
}

- (UIColor *)colorFromRGB:(NSInteger)RGBValue {
    return [UIColor colorWithRed:((float)((RGBValue & 0xFF0000) >> 16))/255.0 green:((float)((RGBValue & 0xFF00) >> 8))/255.0 blue:((float)(RGBValue & 0xFF))/255.0 alpha:1.0];
}

@end
