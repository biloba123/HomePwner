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

+ (instancetype)randomItem {
    // Create an immutable array of three adjectives
    NSArray *randomAdjectiveList = @[@"Fluffy", @"Rusty", @"Shiny"];

    // Create an immutable array of three nouns
    NSArray *randomNounList = @[@"Bear", @"Spork", @"Mac"];

    // Get the index of a random adjective/noun from the lists
    // Note: The % operator, called the modulo operator, gives
    // you the remainder. So adjectiveIndex is a random number
    // from 0 to 2 inclusive.
    NSInteger adjectiveIndex = arc4random() % [randomAdjectiveList count];
    NSInteger nounIndex = arc4random() % [randomNounList count];

    // Note that NSInteger is not an object, but a type definition
    // for "long"

    NSString *randomName = [NSString stringWithFormat:@"%@ %@",
                                                      randomAdjectiveList[adjectiveIndex],
                                                      randomNounList[nounIndex]];

    int randomValue = arc4random() % 100;

    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",
                                                              '0' + arc4random() % 10,
                                                              'A' + arc4random() % 26,
                                                              '0' + arc4random() % 10,
                                                              'A' + arc4random() % 26,
                                                              '0' + arc4random() % 10];

    HPItem *newItem = [[self alloc] initWithItemName:randomName
                                      valueInDollars:randomValue
                                        serialNumber:randomSerialNumber];

    return newItem;
}

- (instancetype)initWithItemName:(NSString *)name
                  valueInDollars:(int)value
                    serialNumber:(NSString *)sNumber {
    // Call the superclass's designated initializer
    self = [super init];

    // Did the superclass's designated initializer succeed?
    if (self) {
        // Give the instance variables initial values
        _itemName = name;
        _serialNumber = sNumber;
        _valueInDollars = value;
        // Set _dateCreated to the current date and time
        _dateCreated = [[NSDate alloc] init];
        _itemKey = [NSUUID new].UUIDString;
    }

    // Return the address of the newly initialized object
    return self;
}

- (instancetype)initWithItemName:(NSString *)name {
    return [self initWithItemName:name
                   valueInDollars:0
                     serialNumber:@""];
}

- (instancetype)init {
    return [self initWithItemName:@"Item"];
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.itemName forKey:@"itemName"];
    [coder encodeObject:self.serialNumber forKey:@"serialNumber"];
    [coder encodeObject:self.dateCreated forKey:@"dateCreated"];
    [coder encodeObject:self.itemKey forKey:@"itemKey"];
    [coder encodeInt:self.valueInDollars forKey:@"valueInDollars"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        _itemName = [coder decodeObjectForKey:@"itemName"];
        _serialNumber = [coder decodeObjectForKey:@"serialNumber"];
        _dateCreated = [coder decodeObjectForKey:@"dateCreated"];
        _itemKey = [coder decodeObjectForKey:@"itemKey"];
        _valueInDollars = [coder decodeIntForKey:@"valueInDollars"];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"Destroyed: %@", self);
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
