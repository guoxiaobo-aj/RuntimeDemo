//
//  ViewController.m
//  RuntimeDemo
//
//  Created by Guoxb on 2019/12/3.
//  Copyright © 2019 Guoxb. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "Animal.h"
#import "Doctor.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *_listArray;
}
@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     * 消息转发
     */
    [[Person new] sendMessage:@"hello"];
    objc_msgSend([Person new], @selector(sendMessage:), @"world");
    
    /*
     * 方法交换
     */
    _listArray = [NSMutableArray array];
    [self.view addSubview:self.myTableView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self->_listArray addObject:@"hello"];
        [self.myTableView reloadData];
    });
    
    /*
     * 字典转模型
     */
    NSDictionary *animalDic = @{@"name": @"dahuang", @"age": @"3"};
    Animal *animal = [[Animal alloc] initWithDic:animalDic];
    NSDictionary *modelDic = [animal convertModelToDic];
    NSLog(@"%@", modelDic);
    
    /*
     * 自定义KVO
     */
    Doctor *doctor = [[Doctor alloc] init];
    doctor.name = @"guoxb";
    [doctor addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    doctor.name = @"zhaopeng";
    
    Doctor *doctor2 = [[Doctor alloc] init];
    [doctor2 lg_addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    doctor2.name = @"Tom";
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"change == %@", change);
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"tableViewCell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    return cell;
}

#pragma mark - LazyLoad

- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
    }
    return _myTableView;
}


@end
