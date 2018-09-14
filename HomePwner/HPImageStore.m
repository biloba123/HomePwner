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

- (instancetype)initPrivate {
    if (self = [super init]) {
        _dictionary = [NSMutableDictionary new];
        [[NSNotificationCenter defaultCenter]
                addObserver:self
                   selector:@selector(clearCache:)
                       name:UIApplicationDidReceiveMemoryWarningNotification
                     object:nil];
    }
    return self;
}

+ (instancetype)getInstance {
    static HPImageStore *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HPImageStore alloc] initPrivate];
    });
    return instance;
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key {
    self.dictionary[key] = image;
    NSString *imgPath = [self imagePathForKey:key];
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    NSLog(@"%s jpeg:%lu", sel_getName(_cmd), data.length);
    [data writeToFile:imgPath atomically:YES];
}

- (UIImage *)imageForKey:(NSString *)key {
    UIImage *img = self.dictionary[key];
    if (!img) {
        NSString *imgPath = [self imagePathForKey:key];
        if (img = [UIImage imageWithContentsOfFile:imgPath]) {
            self.dictionary[key]=img;
        } else{
            NSLog(@"%s can not to load image", sel_getName(_cmd));
        }
    }
    return img;
}

- (void)deleteImageForKey:(NSString *)key {
    [self.dictionary removeObjectForKey:key];
    [[NSFileManager defaultManager]
            removeItemAtPath:[self imagePathForKey:key] error:nil];
}

- (NSString *)imagePathForKey:(NSString *)key {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
            .firstObject stringByAppendingPathComponent:key];
}

- (void)clearCache:(id)sender {
    NSLog(@"%s receive memory warning", sel_getName(_cmd));
    [self.dictionary removeAllObjects];
}

@end