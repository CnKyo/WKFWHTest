//
//  AppDelegate.m
//  kTest
//
//  Created by wangke on 15/12/18.
//  Copyright © 2015年 wangke. All rights reserved.
//

#import "AppDelegate.h"
#import "FWHLoginViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    

    
    [MobClick startWithAppkey:@"84d5d4fcac0875291c98fa0e" reportPolicy:BATCH   channelId:@"App Store"];
    
    [mAppInfo getAppGinfo:^(mBaseModel *mData, mAppInfo *mInfo) {
        if (mData.mSucsess) {
            lll(@"初始化成功");
        }else{
            lll(@"初始化失败");

        }
    }];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    lll(@"错误信息：%@",error);
}
- (void)gotoLogin{
    UINavigationController* nav = (UINavigationController*)((UITabBarController*)self.window.rootViewController).selectedViewController;
    
    if ( [nav.topViewController isKindOfClass:[FWHLoginViewController class]] ) {
        return;
    }
    ///登录前记得退出
    UIStoryboard    *story = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    id loginvc = [story instantiateViewControllerWithIdentifier:@"login"];
    
    [(UINavigationController*)((UITabBarController *)self.window.rootViewController).selectedViewController pushViewController:loginvc animated:YES];
}
- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    NSLog(@"tag:%@ alias%@ irescod:%d",tags,alias,iResCode);
    if (iResCode == 6002) {
        [mUser openTokenWithPush];
    }
}
@end
