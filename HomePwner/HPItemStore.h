//
// Created by 吕晴阳 on 2018/9/6.
// Copyright (c) 2018 Lv Qingyang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HPItem;

@interface HPItemStore : NSObject
@property (nonatomic, readonly) NSArray *allItems;

+(instancetype)getInstance;
-(HPItem *)createItem;
-(NSArray *)valueMoreThan50Items;
-(NSArray *)otherItems;
@end