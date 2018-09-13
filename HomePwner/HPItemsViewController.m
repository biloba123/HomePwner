//
// Created by 吕晴阳 on 2018/9/6.
// Copyright (c) 2018 Lv Qingyang. All rights reserved.
//

#import "HPItemsViewController.h"
#import "HPItemStore.h"
#import "HPDetailViewController.h"

@interface HPItemsViewController ()
//@property(nonatomic, strong) IBOutlet UIView *headerView;
//@property(nonatomic, strong) IBOutlet UIView *footerView;
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
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"HomePwner";
        UIBarButtonItem *addBtnItem = [[UIBarButtonItem alloc]
                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                     target:self
                                     action:@selector(addNewItem:)];
        navItem.rightBarButtonItem = addBtnItem;
        navItem.leftBarButtonItem = self.editButtonItem;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
//    self.tableView.tableHeaderView = self.headerView;
//    self.tableView.tableFooterView = self.footerView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.tableView reloadData];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HPDetailViewController *detailViewController = [HPDetailViewController new];
    detailViewController.item = _itemStore.allItems[indexPath.row];
    [self.navigationController pushViewController:detailViewController
                                         animated:YES];
}

- (IBAction)addNewItem:(id)sender {
    [_itemStore createItem];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_itemStore allItems].count - 1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (IBAction)toggleEditingMode:(UIButton *)sender {
    if (self.isEditing) {
        [sender setTitle:@"Edit"
                forState:UIControlStateNormal];
        [self setEditing:NO
                animated:YES];
    } else {
        [sender setTitle:@"Done"
                forState:UIControlStateNormal];
        [self setEditing:YES
                animated:YES];
    }
}


//- (UIView *)headerView {
//    if (!_headerView) {
//        [[NSBundle mainBundle] loadNibNamed:@"HeaderView"
//                                      owner:self
//                                    options:nil];
//    }
//    return _headerView;
//}
//
//- (UIView *)footerView {
//    if (!_footerView) {
//        [[NSBundle mainBundle] loadNibNamed:@"FooterView"
//                                      owner:self
//                                    options:nil];
//    }
//    return _footerView;
//}

@end