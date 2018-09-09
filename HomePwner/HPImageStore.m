//
// Created by 吕晴阳 on 2018/9/9.
// Copyright (c) 2018 Lv Qingyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CloudKit/CloudKit.h>
#import "HPImageStore.h"

@interface HPImageStore ()
@property(nonatomic) NSMutableDictionary *dictionary;
@end

@implementation HPImageStore {

}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"use [HPImageStore getInstance]"
                                 userInfo:nil];
    return nil;
}

-(instancetype)initPrivate {
    if(self= [super init]){
        _dictionary = [NSMutableDictionary new];
    }
    return self;
}

+ (instancetype)getInstance {
    static HPImageStore *instance=nil;
    if(!instance){
        instance= [[HPImageStore alloc] initPrivate];
    }
    return instance;
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key {
    self.dictionary[key]=image;
}

- (UIImage *)imageForKey:(NSString *)key {
    return self.dictionary[key];
}

- (void)deleteImageForKey:(NSString *)key {
    [self.dictionary removeObjectForKey:key];
}

@end