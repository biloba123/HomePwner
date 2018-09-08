//
//  HPDetailViewController.m
//  HomePwner
//
//  Created by 吕晴阳 on 2018/9/7.
//  Copyright © 2018年 Lv Qingyang. All rights reserved.
//

#import "HPDetailViewController.h"
#include "HPItem.h"

@interface HPDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation HPDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    HPItem *item=self.item;
    self.nameField.text=item.itemName;
    self.serialNumberField.text=item.serialNumber;
    self.valueField.text= [NSString stringWithFormat:@"%d", item.valueInDollars];
    static NSDateFormatter *formatter=nil;
    if(!formatter){
        formatter= [NSDateFormatter new];
        formatter.dateStyle=NSDateFormatterMediumStyle;
        formatter.timeStyle=NSDateFormatterNoStyle;
    }
    self.dateLabel.text= [formatter stringFromDate:item.dateCreated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    self.item.itemName=self.nameField.text;
    self.item.serialNumber=self.serialNumberField.text;
    self.item.valueInDollars= [self.valueField.text intValue];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setItem:(HPItem *)item {
    _item=item;
    self.navigationItem.title=item.itemName;
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
