//
//  AppDelegate.m
//  YouTubeAPP
//
//  Created by Admin on 21.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "AppDelegate.h"
#import "MasterViewController.h"
#import "SearchViewController.h"
#import "DetailViewController.h"
#import "SmallVideoController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    NSString *developerKey = @"AIzaSyAUax-Gjc6Dlech0E0hXsR30WKX2i5TGtA";
    MasterViewController *MasterViewControler = [[MasterViewController alloc] init];
    MasterViewControler.DEV_KEY = developerKey;
    UINavigationController *MasterNavigationController = [[UINavigationController alloc] initWithRootViewController:MasterViewControler];
    UINavigationController *SearchNavigationController = [UINavigationController alloc];
    SearchViewController *searchViewController = [[SearchViewController alloc] init];
       searchViewController.DEV_KEY = developerKey;
    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    detailViewController.DEV_KEY = developerKey;
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    UIImage *SearchImage = [UIImage imageNamed:@"search.png"];
    UIImage *SearchImageSel = [UIImage imageNamed:@"search.png"];
    UIImage *HomeImage = [UIImage imageNamed:@"home.png"];
    UIImage *HomeImageSel = [UIImage imageNamed:@"home.png"];
    SearchImage = [SearchImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    SearchImageSel = [SearchImageSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    HomeImage = [HomeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    HomeImageSel = [HomeImageSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    searchViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Поиск" image:SearchImage selectedImage:SearchImageSel];
    MasterViewControler.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Главная" image:HomeImage selectedImage:HomeImageSel];
    [self.window setRootViewController:tabBarController];
    [tabBarController setViewControllers:@[MasterNavigationController, searchViewController]];
    [self.window setBackgroundColor:[UIColor grayColor]];
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
