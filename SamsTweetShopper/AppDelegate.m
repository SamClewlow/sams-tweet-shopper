//
//  AppDelegate.m
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 02/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import "AppDelegate.h"

// Module Protocols
#import "STSSearchInputModuleInterface.h"
#import "STSFavoritesModuleInterface.h"

// Wireframes
#import "STSSearchInputWireframe.h"
#import "STSFavoritesWireframe.h"


#pragma mark - Interface

@interface AppDelegate ()

@property (nonatomic, strong) UITabBarController *tabBarController;
@property (nonatomic, strong) id<STSSearchInputModuleInterface> searchInputModule;
@property (nonatomic, strong) id<STSFavoritesModuleInterface> favoritesModule;

@end


#pragma mark - Implementation

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Initialise the module interface we need the AppDelegate to hold a stron reference to.
    // In a real world scenario, this would be done with a dependency injection framework (such as Typhoon)
    // to preserve the sanctity of the protocol based interfaces.
    self.searchInputModule = [[STSSearchInputWireframe alloc] init];
    self.favoritesModule = [[STSFavoritesWireframe alloc] init];
    
    self.tabBarController = [[UITabBarController alloc] init];
    UINavigationController *searchNavigationController = [self.searchInputModule getUserInterface];
    UINavigationController *favoritesNavigationController = [self.favoritesModule getUserInterface];
    
    [self.tabBarController setViewControllers:@[searchNavigationController, favoritesNavigationController]];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
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

@end
