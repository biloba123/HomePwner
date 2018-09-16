//
//  HPItem.h
//  RandomItems
//
//  Created by John Gallagher on 1/12/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface HPItem : NSObject<NSCoding>

@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *serialNumber;
@property (nonatomic) int valueInDollars;
@property (nonatomic, readonly) NSDate *dateCreated;
@property (nonatomic, copy) NSString *itemKey;
@property (nonatomic) UIImage *thumbnail;

+ (instancetype)randomItem;

// Designated initializer for HPItem
- (instancetype)initWithItemName:(NSString *)name
                  valueInDollars:(int)value
                    serialNumber:(NSString *)sNumber;

- (instancetype)initWithItemName:(NSString *)name;

-(void)setThumbnailFromImage:(UIImage *)image;

@end
