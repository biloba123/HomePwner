//
//  HPItem.m
//  RandomItems
//
//  Created by John Gallagher on 1/12/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "HPItem.h"

@implementation HPItem

- (void)awakeFromInsert {
    [super awakeFromInsert];

    self.dateCreated= [NSDate date];
    self.itemKey= [[NSUUID new] UUIDString];
}

- (void)setThumbnailFromImage:(UIImage *)image {
    CGRect newRect = CGRectMake(0, 0, 40, 40);
    float ratio = MAX(newRect.size.width / image.size.width, newRect.size.height / image.size.height);

    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:newRect
                                                          cornerRadius:5.0];
    [bezierPath addClip];

    CGRect projectRect;
    projectRect.size.width=image.size.width*ratio;
    projectRect.size.height=image.size.height*ratio;
    projectRect.origin.x=(projectRect.size.width-newRect.size.width)/-2;
    projectRect.origin.y=(projectRect.size.height-newRect.size.height)/-2;
    [image drawInRect:projectRect];

    self.thumbnail= UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
}

- (NSString *)description {
    NSString *descriptionString =
            [[NSString alloc] initWithFormat:@"%@ (%@): Worth $%d, recorded on %@",
                                             self.itemName,
                                             self.serialNumber,
                                             self.valueInDollars,
                                             self.dateCreated];
    return descriptionString;
}

@end
