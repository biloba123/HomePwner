//
//  HPDetailViewController.m
//  HomePwner
//
//  Created by 吕晴阳 on 2018/9/7.
//  Copyright © 2018年 Lv Qingyang. All rights reserved.
//

#import "HPDetailViewController.h"
#include "HPItem.h"
#import "HPImageStore.h"
#import "HPItemStore.h"

@interface HPDetailViewController () <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property(weak, nonatomic) IBOutlet UITextField *nameField;
@property(weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property(weak, nonatomic) IBOutlet UITextField *valueField;
@property(weak, nonatomic) IBOutlet UILabel *dateLabel;
@property(weak, nonatomic) IBOutlet UIImageView *imageView;
@property(weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property(weak, nonatomic) IBOutlet UIBarButtonItem *cameraBun;

@end

@implementation HPDetailViewController

#pragma mark - Init methods

- (instancetype)initForAddItem:(BOOL)isAdd {
    if (isAdd) {
        UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc]
                initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                     target:self
                                     action:@selector(cancel:)];
        self.navigationItem.leftBarButtonItem = cancelBtn;
        UIBarButtonItem *addBtn = [[UIBarButtonItem alloc]
                initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                     target:self
                                     action:@selector(add:)];
        self.navigationItem.rightBarButtonItem = addBtn;
    }
    return self;
}

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil {
    @throw [NSException exceptionWithName:@"Init exception"
                                   reason:@"use initForAddItem: to init"
                                 userInfo:nil];
    return nil;
}


#pragma mark - View life cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self prepareViewsForOrientation:[self interfaceOrientation]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    self.item.itemName = self.nameField.text;
    self.item.serialNumber = self.serialNumberField.text;
    self.item.valueInDollars = [self.valueField.text intValue];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.nameField.delegate = self;
    self.serialNumberField.delegate = self;

    HPItem *item = self.item;
    self.nameField.text = item.itemName;
    self.serialNumberField.text = item.serialNumber;
    self.valueField.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
    static NSDateFormatter *formatter = nil;
    if (!formatter) {
        formatter = [NSDateFormatter new];
        formatter.dateStyle = NSDateFormatterMediumStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
    }
    self.dateLabel.text = [formatter stringFromDate:item.dateCreated];

    UIImageView *iv = [UIImageView new];
    iv.contentMode = UIViewContentModeScaleAspectFit;
    iv.translatesAutoresizingMaskIntoConstraints = NO;
//    @"H:|-0-[iv]-0-|";
//    @"V:[dateLabel]-8-[iv]-16-[toolbar]";
    [self.view addSubview:iv];
    self.imageView = iv;

    NSDictionary *nameMap = @{
            @"imageView": self.imageView,
            @"dateLabel": self.dateLabel,
            @"toolbar": self.toolbar
    };
    NSArray *horConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:nameMap];
    NSArray *verConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[dateLabel]-16-[imageView]-16-[toolbar]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:nameMap];
    [self.view addConstraints:horConstraints];
    [self.view addConstraints:verConstraints];
    [self showImg:[[HPImageStore getInstance] imageForKey:item.itemKey]];

}

#pragma mark - Controller events

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Actions

- (IBAction)takePicture:(id)sender {
    NSLog(@"%s", sel_getName(_cmd));
    UIImagePickerController *imagePickerController = [UIImagePickerController new];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagePickerController.allowsEditing = YES;
    imagePickerController.delegate = self;

    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        imagePickerController.modalPresentationStyle = UIModalPresentationPopover;
        UIPopoverPresentationController *imagePickerPopover = imagePickerController.popoverPresentationController;
        imagePickerPopover.permittedArrowDirections = UIPopoverArrowDirectionAny;
        imagePickerPopover.barButtonItem = sender;
        imagePickerPopover.backgroundColor = [UIColor whiteColor];

    }
    [self presentViewController:imagePickerController
                       animated:YES
                     completion:nil];
}

- (IBAction)deleteImg:(id)sender {
    [[HPImageStore getInstance] deleteImageForKey:self.item.itemKey];
    [self showImg:nil];
}

#pragma mark - Image picker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info {
    UIImage *img = info[UIImagePickerControllerEditedImage];
    [self.item setThumbnailFromImage:img];
    [[HPImageStore getInstance] setImage:img forKey:self.item.itemKey];
    [self showImg:img];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Other

- (void)setItem:(HPItem *)item {
    _item = item;
    self.navigationItem.title = item.itemName;
}

- (void)showImg:(UIImage *)image {
    self.imageView.image = image;
}

//- (void)viewDidLayoutSubviews {
//    for (UIView *v in self.view.subviews) {
//        if ([v hasAmbiguousLayout]) {
//            NSLog(@"%s %@", sel_getName(_cmd), v);
//        }
//    }
//}

- (IBAction)backgroundTapped:(id)sender {
    NSLog(@"%s", sel_getName(_cmd));
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self prepareViewsForOrientation:toInterfaceOrientation];
}

- (void)prepareViewsForOrientation:(UIInterfaceOrientation)orientation {
    NSLog(@"%s %ld", sel_getName(_cmd), orientation);
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return;
    }

    if (UIInterfaceOrientationIsLandscape(orientation)) {
        self.cameraBun.enabled = NO;
        self.imageView.hidden = YES;
    } else {
        self.cameraBun.enabled = YES;
        self.imageView.hidden = NO;
    }
}

#pragma mark - Navigation item

- (void)cancel:(id)sender {
    [[HPImageStore getInstance] deleteImageForKey:self.item.itemKey];
    [[HPItemStore getInstance] removeItem:self.item];
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:self.dismissBlock];
}

- (void)add:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:self.dismissBlock];
}

@end
