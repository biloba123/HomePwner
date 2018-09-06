//
// Created by 吕晴阳 on 2018/9/6.
// Copyright (c) 2018 Lv Qingyang. All rights reserved.
//

#import "HPItemsViewController.h"
#import "HPItemStore.h"


@implementation HPItemsViewController {
    HPItemStore *_itemStore;
    NSArray *valueMoreThan50Items;
    NSArray *otherItems;
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
        valueMoreThan50Items= [_itemStore valueMoreThan50Items];
        otherItems= [_itemStore otherItems];
        NSLog(@"%s %@ %@", sel_getName(_cmd), valueMoreThan50Items, otherItems);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s %@", sel_getName(_cmd), indexPath);
    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    tableViewCell.textLabel.text = [(indexPath.section==0?valueMoreThan50Items:otherItems)[indexPath.row] description];
    return tableViewCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section==0?valueMoreThan50Items.count:otherItems.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section==0?@"value >= 50":@"other";
}
@end