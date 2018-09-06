//
// Created by 吕晴阳 on 2018/9/6.
// Copyright (c) 2018 Lv Qingyang. All rights reserved.
//

#import <EventKit/EventKit.h>
#import "HPItemStore.h"
#import "HPItem.h"
@interface HPItemStore()
@property (nonatomic) NSMutableArray *privateItems;
@end

@implementation HPItemStore {

}
- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"use [HPItemStore getInstance]"
                                 userInfo:nil];
    return nil;
}

-(instancetype) initPrivate{
    if(self= [super init]){
        _privateItems= [NSMutableArray new];
    }
    return self;
}

+ (instancetype)getInstance {
    static HPItemStore *instance=nil;
    if(instance==nil){
        instance= [[HPItemStore alloc] initPrivate];
    }
    return instance;
}

- (HPItem *)createItem {
    HPItem *item= [HPItem randomItem];
    [self.privateItems addObject:item];
    return item;
}

- (NSArray *)allItems {
    return [self privateItems];
}



@end