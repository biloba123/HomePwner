//
//  AppDelegate.m
//  HomePwner
//
//  Created by 吕晴阳 on 2018/9/6.
//  Copyright © 2018年 Lv Qingyang. All rights reserved.
//

#import "AppDelegate.h"
#import "HPItemsViewController.h"
#import "HPNavigationController.h"
#import "HPItemStore.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions {
    NSLog(@"%s %@", sel_getName(_cmd), [NSBundle mainBundle].bundlePath);
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSLog(@"%s", sel_getName(_cmd));
    self.window= [UIWindow new];
    self.window.frame= [UIScreen mainScreen].bounds;
    HPItemsViewController *itemsViewController= [[HPItemsViewController alloc] init];
    UINavigationController *navController= [[HPNavigationController alloc] initWithRootViewController:itemsViewController];
    self.window.rootViewController=navController;
    self.window.backgroundColor= [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"%s", sel_getName(_cmd));
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    NSLog(@"%s", sel_getName(_cmd));
}



- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"%s", sel_getName(_cmd));
    if([[HPItemStore getInstance] saveChanges]){
        NSLog(@"%s save items succ", sel_getName(_cmd));
    } else{
        NSLog(@"%s save items failed", sel_getName(_cmd));
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    NSLog(@"%s", sel_getName(_cmd));
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"%s", sel_getName(_cmd));
}


@end
