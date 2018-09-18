//
//  HPItem.h
//  RandomItems
//
//  Created by John Gallagher on 1/12/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface HPItem : NSManagedObject

@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *serialNumber;
@property (nonatomic) int valueInDollars;
@property (nonatomic) NSDate *dateCreated;
@property (nonatomic, copy) NSString *itemKey;
@property (nonatomic) UIImage *thumbnail;
@property (nonatomic) double orderingValue;
@property (nonatomic) NSManagedObject *assetType;

-(void)setThumbnailFromImage:(UIImage *)image;

@end
