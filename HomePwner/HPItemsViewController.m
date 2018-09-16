//
// Created by 吕晴阳 on 2018/9/6.
// Copyright (c) 2018 Lv Qingyang. All rights reserved.
//

#import "HPItemsViewController.h"
#import "HPItemStore.h"
#import "HPDetailViewController.h"
#import "HPItem.h"
#import "HPItemCell.h"
#import "HPImageViewController.h"
#import "HPImageStore.h"


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
//    [self.tableView registerClass:[HPItemCell class]
//           forCellReuseIdentifier:@"UITableViewCell"];
    UINib *nib= [UINib nibWithNibName:@"HPItemCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"HPItemCell"];
//    self.tableView.tableHeaderView = self.headerView;
//    self.tableView.tableFooterView = self.footerView;
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"%s", sel_getName(_cmd));
    [super viewWillAppear:YES];
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HPItem *item=_itemStore.allItems[indexPath.row];
    HPItemCell *itemCell = [tableView dequeueReusableCellWithIdentifier:@"HPItemCell"];
    itemCell.nameLabel.text=item.itemName;
    itemCell.serialNumberLabel.text=item.serialNumber;
//    if(item.valueInDollars<=50){
//        itemCell.valueLabel.textColor= [UIColor redColor];
//    } else{
//        itemCell.valueLabel.textColor= [UIColor greenColor];
//    }
    itemCell.valueLabel.text= [NSString stringWithFormat:@"%d", item.valueInDollars];
    itemCell.imageView.image=item.thumbnail;
    __weak HPItemCell *weakCell=itemCell;
    itemCell.actionBlock=^(){
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad){
            __strong HPItemCell *strongCell=weakCell;
            HPImageViewController *imageViewController= [HPImageViewController new];
            imageViewController.image= [[HPImageStore getInstance] imageForKey:item.itemKey];
            imageViewController.modalPresentationStyle=UIModalPresentationPopover;
            imageViewController.preferredContentSize=CGSizeMake(600, 600);
            UIPopoverPresentationController *popover=imageViewController.popoverPresentationController;
            popover.sourceView=strongCell;
            popover.permittedArrowDirections=UIPopoverArrowDirectionAny;
            [self presentViewController:imageViewController animated:YES completion:nil];
        }
    };
//    [UIImagePNGRepresentation(item.thumbnail) writeToFile:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
//            .firstObject stringByAppendingPathComponent:item.itemName] atomically:YES];
    return itemCell;
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
    HPDetailViewController *detailViewController = [[HPDetailViewController alloc] initForAddItem:NO];
    detailViewController.item = _itemStore.allItems[indexPath.row];
    [self.navigationController pushViewController:detailViewController
                                         animated:YES];
}

- (IBAction)addNewItem:(id)sender {
    HPDetailViewController *detailViewController= [[HPDetailViewController alloc] initForAddItem:YES];
    detailViewController.item= [HPItem new];
    detailViewController.dismissBlock=^(){
        [self.tableView reloadData];
    };
    UINavigationController *navigationController1= [[UINavigationController alloc] initWithRootViewController:detailViewController];
    navigationController1.modalPresentationStyle=UIModalPresentationFormSheet;
    navigationController1.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    [self presentViewController:navigationController1 animated:YES completion:nil];
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