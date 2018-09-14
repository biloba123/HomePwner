//
//  HPDetailViewController.h
//  HomePwner
//
//  Created by 吕晴阳 on 2018/9/7.
//  Copyright © 2018年 Lv Qingyang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HPItem;
@interface HPDetailViewController : UIViewController
@property (nonatomic) HPItem *item;
@property (nonatomic, copy) void(^dismissBlock)(void);

-(instancetype) initForAddItem:(BOOL)isAdd;
@end
