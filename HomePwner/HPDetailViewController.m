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

@interface HPDetailViewController () <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property(weak, nonatomic) IBOutlet UITextField *nameField;
@property(weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property(weak, nonatomic) IBOutlet UITextField *valueField;
@property(weak, nonatomic) IBOutlet UILabel *dateLabel;
@property(weak, nonatomic) IBOutlet UIImageView *imageView;
@property(weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property(weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *deleteImgBtn;

@end

@implementation HPDetailViewController

#pragma mark - View life cycle
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
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 680);

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
    imagePickerController.allowsEditing=YES;
    imagePickerController.mediaTypes=
    imagePickerController.delegate = self;

    [self presentViewController:imagePickerController
                       animated:YES
                     completion:^{
                         NSLog(@"presentViewController");
                     }];
}

- (IBAction)deleteImg:(id)sender {
    [[HPImageStore getInstance] deleteImageForKey:self.item.itemKey];
    [self showImg:nil];
}

#pragma mark - Image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info {
    UIImage *img = info[UIImagePickerControllerEditedImage];
    [[HPImageStore getInstance] setImage:img forKey:self.item.itemKey];
    [self showImg:img];
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"dismissViewControllerAnimated");
    }];
}

#pragma mark - Other
- (void)setItem:(HPItem *)item {
    _item = item;
    self.navigationItem.title = item.itemName;
}

- (void)showImg:(UIImage *)image {
    self.imageView.image = image;
    self.deleteImgBtn.hidden=image==nil;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
