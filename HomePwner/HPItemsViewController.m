//
// Created by 吕晴阳 on 2018/9/6.
// Copyright (c) 2018 Lv Qingyang. All rights reserved.
//

#import "HPItemsViewController.h"
#import "HPItemStore.h"


@implementation HPItemsViewController {
    HPItemStore *_itemStore;
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [self init];
}

- (instancetype)init {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        _itemStore = [HPItemStore getInstance];
        for (int i = 0; i < 20; ++i) {
            [_itemStore createItem];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    tableViewCell.textLabel.text = [_itemStore.allItems[indexPath.row] description];
    return tableViewCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_itemStore.allItems count];
}

@end