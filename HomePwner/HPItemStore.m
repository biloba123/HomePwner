//
// Created by 吕晴阳 on 2018/9/6.
// Copyright (c) 2018 Lv Qingyang. All rights reserved.
//

#import <EventKit/EventKit.h>
#import "HPItemStore.h"
#import "HPItem.h"
#import "HPImageStore.h"

@interface HPItemStore ()
@property(nonatomic, strong) NSMutableArray *privateItems;
@property(nonatomic, strong) NSMutableArray *allAssetTypes;
@property(nonatomic, strong) NSManagedObjectModel *model;
@property(nonatomic, strong) NSManagedObjectContext *context;
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
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];

        for (NSEntityDescription *entity in _model.entities) {
            NSLog(@"[%@ %s] %@", self.class, sel_getName(_cmd), entity.name);
        }

        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        NSURL *url = [NSURL fileURLWithPath:[self itemArchivePath]];
        NSError *error = nil;
        if (![coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error]) {
            [NSException raise:@"OpenFailure" format:@"Reason: %@", [error localizedDescription]];
        }

        _context = [NSManagedObjectContext new];
        _context.persistentStoreCoordinator = coordinator;

        [self loadAllItems];
    }
    return self;
}

+ (instancetype)getInstance {
    static HPItemStore *instance = nil;

    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[HPItemStore alloc] initPrivate];
    });

    return instance;
}


#pragma mark - Crud

- (void)loadAllItems {
    if (!self.privateItems) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"HPItem"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"orderingValue" ascending:YES]];

        NSError *error = nil;
        NSArray *items = [self.context executeFetchRequest:request error:nil];
        if (!items) {
            [NSException raise:@"FetchFailure" format:@"Reason: %@", [error localizedDescription]];
        }

        self.privateItems = [NSMutableArray arrayWithArray:items];
    }

    NSLog(@"[%@ %s] %@", self.class, sel_getName(_cmd), self.allItems);
}

- (BOOL)saveChanges {
    NSLog(@"[%@ %s] %@", self.class, sel_getName(_cmd), self.allItems);
    NSError *error = nil;
    BOOL successful = [_context save:&error];
    if (!successful) {
        NSLog(@"%s Save failed: %@", sel_getName(_cmd), [error localizedDescription]);
    }
    
    return successful;
}

- (HPItem *)createItem {
    HPItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"HPItem" inManagedObjectContext:self.context];

    if (self.privateItems.count == 0) {
        item.orderingValue = 1.0;
    } else {
        item.orderingValue = [[self.privateItems lastObject] orderingValue] + 1.0;
    }

    NSLog(@"%s ordering: %.2f", sel_getName(_cmd), item.orderingValue);

    [self.privateItems addObject:item];
    return item;
}

- (void)removeItem:(HPItem *)item {
    [self.context deleteObject:item];
    [[HPImageStore getInstance] deleteImageForKey:item.itemKey];
    [self.privateItems removeObjectIdenticalTo:item];
}

- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    if (fromIndex == toIndex) return;
    HPItem *item = self.privateItems[fromIndex];
    [self.privateItems removeObjectAtIndex:fromIndex];
    [self.privateItems insertObject:item atIndex:toIndex];

    double lower;
    if (toIndex == 0) {
        lower = [self.privateItems[1] orderingValue] - 2.0;
    } else {
        lower = [self.privateItems[toIndex - 1] orderingValue];
    }

    double upper;
    if (toIndex == [self.privateItems count] - 1) {
        upper = [self.privateItems[self.privateItems.count - 2] orderingValue] + 2.0;
    } else {
        upper = [self.privateItems[toIndex + 1] orderingValue];
    }

    double ordering = (lower + upper) / 2;
    NSLog(@"%s Move item from %d to %d, ordering: %.2f", sel_getName(_cmd), fromIndex, toIndex, ordering);
    item.orderingValue = ordering;
}

#pragma mark - Other

- (NSArray *)allItems {
    return self.privateItems;
}


- (NSString *)itemArchivePath {
    return [[NSSearchPathForDirectoriesInDomains(
            NSDocumentDirectory, NSUserDomainMask, YES
    ) firstObject] stringByAppendingPathComponent:@"store.data"];
}


@end
