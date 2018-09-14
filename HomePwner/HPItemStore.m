//
// Created by 吕晴阳 on 2018/9/6.
// Copyright (c) 2018 Lv Qingyang. All rights reserved.
//

#import <EventKit/EventKit.h>
#import "HPItemStore.h"
#import "HPItem.h"
#import "HPImageStore.h"

@interface HPItemStore ()
@property(nonatomic) NSMutableArray *privateItems;
@end

@implementation HPItemStore {

}
- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"use [HPItemStore getInstance]"
                                 userInfo:nil];
    return nil;
}

- (instancetype)initPrivate {
    if (self = [super init]) {
        _privateItems= [NSKeyedUnarchiver unarchiveObjectWithFile:[self itemArchivePath]];
        if(!_privateItems) {
            _privateItems = [NSMutableArray new];
        }
    }
    return self;
}

+ (instancetype)getInstance {
    static HPItemStore *instance = nil;
    if (instance == nil) {
        instance = [[HPItemStore alloc] initPrivate];
    }
    NSLog(@"%s %@", sel_getName(_cmd), [instance itemArchivePath]);
    return instance;
}

- (HPItem *)createItem {
    HPItem *item = [HPItem new];
    [self.privateItems addObject:item];
    return item;
}

- (void)removeItem:(HPItem *)item {
    [[HPImageStore getInstance] deleteImageForKey:item.itemName];
    [self.privateItems removeObjectIdenticalTo:item];
}

- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    if (fromIndex == toIndex) return;
    HPItem *item = self.privateItems[fromIndex];
    [self.privateItems removeObjectAtIndex:fromIndex];
    [self.privateItems insertObject:item atIndex:toIndex];
}

- (void)addItem:(HPItem *)item {
    [self.privateItems addObject:item];
}

- (BOOL)saveChanges {
    return [NSKeyedArchiver archiveRootObject:self.privateItems toFile:[self itemArchivePath]];
}


- (NSArray *)allItems {
    return self.privateItems;
}


- (NSString *)itemArchivePath {
    return [[NSSearchPathForDirectoriesInDomains(
            NSDocumentDirectory, NSUserDomainMask, YES
    ) firstObject] stringByAppendingPathComponent:@"items.archive"];
}


@end