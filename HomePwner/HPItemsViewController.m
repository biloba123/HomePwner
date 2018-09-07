//
// Created by 吕晴阳 on 2018/9/6.
// Copyright (c) 2018 Lv Qingyang. All rights reserved.
//

#import "HPItemsViewController.h"
#import "HPItemStore.h"

@interface HPItemsViewController ()
@property(nonatomic, strong) IBOutlet UIView *headerView;
@property(nonatomic, strong) IBOutlet UIView *footerView;
@end

@implementation HPItemsViewController {
    HPItemStore *_itemStore;
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [self init];
}

- (instancetype)init {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        _itemStore = [HPItemStore getInstance];
//        for (int i = 0; i < 20; ++i) {
//            [_itemStore createItem];
//        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    tableViewCell.textLabel.text = [_itemStore.allItems[indexPath.row] description];
    return tableViewCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_itemStore.allItems count];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (editingStyle) {
        case UITableViewCellEditingStyleDelete:
            [_itemStore removeItem:_itemStore.allItems[indexPath.row]];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
    NSLog(@"%s %@", sel_getName(_cmd), [_itemStore allItems]);
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [_itemStore moveItemAtIndex:sourceIndexPath.row
                        toIndex:destinationIndexPath.row];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"remove";
}

- (IBAction)addNewItem:(id)sender {
    [_itemStore createItem];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_itemStore allItems].count - 1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (IBAction)toggleEditingMode:(id)sender {
    if (self.isEditing) {
        [((UIButton *) sender) setTitle:@"Edit"
                               forState:UIControlStateNormal];
        [self setEditing:NO
                animated:YES];
    } else {
        [((UIButton *) sender) setTitle:@"Done"
                               forState:UIControlStateNormal];
        [self setEditing:YES
                animated:YES];
    }
}

- (UIView *)headerView {
    if (!_headerView) {
        [[NSBundle mainBundle] loadNibNamed:@"HeaderView"
                                      owner:self
                                    options:nil];
    }
    return _headerView;
}

- (UIView *)footerView {
    if (!_footerView) {
        [[NSBundle mainBundle] loadNibNamed:@"FooterView"
                                      owner:self
                                    options:nil];
    }
    return _footerView;
}

@end