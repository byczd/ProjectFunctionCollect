//
//  AppDelegate.m
//  YMOCCodeStandard
//
//  Created by iOS on 2018/9/10.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+YMLocalNotification.h"
#import "YMUITabBarController.h"
#import <WXApi.h>

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // MARK: pushKit
    [self registerPushKit];
    // MARK: 加载 windows
    [self loadWindows];
    // MARK: 向微信注册
    [WXApi registerApp:@"wx14fa72d3ae5fb6ce" enableMTA:YES];
    // MARK: 键盘管理者
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    return YES;
}

#pragma mark -- loadWindows
- (void)loadWindows {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    YMUITabBarController *tabBarVc = [[YMUITabBarController alloc] init];
    self.window.rootViewController = tabBarVc;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}

#pragma mark - - iOS9 之后使用的方法
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    
    if ([url.scheme isEqualToString:@"wx3343434343434"]) {
        return  [WXApi handleOpenURL:url delegate:(id<WXApiDelegate>)self];
    }
    return YES;
}

#pragma mark - - iOS9 之前使用的方法
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([url.scheme isEqualToString:@"wx3343434343434"]) {
        return  [WXApi handleOpenURL:url delegate:(id<WXApiDelegate>)self];
    }
    return YES;
}

#pragma mark - - iOS9 之前使用的方法
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.scheme isEqualToString:@"wx3343434343434"]) {
        return  [WXApi handleOpenURL:url delegate:(id<WXApiDelegate>)self];
    }
    return YES;
}

#pragma mark - - 微信支付回调
- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[PayResp class]]) {
        switch (resp.errCode) {
            case WXSuccess:
            {
                NSNotification *notification = [NSNotification notificationWithName:@"ORDER_PAY_NOTIFICATION" object:@"success"];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }
                break;
                
            default:
            {
                NSNotification *notification = [NSNotification notificationWithName:@"ORDER_PAY_NOTIFICATION"object:@"fail"];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }
                break;
        }
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"YMOCCodeStandard"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
