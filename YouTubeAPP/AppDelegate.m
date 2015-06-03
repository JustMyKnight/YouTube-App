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
@interface AppDelegate ()

@end

//App init
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    NSString *developerKey = @"AIzaSyAUax-Gjc6Dlech0E0hXsR30WKX2i5TGtA"; //create developer key for work with YouTube api
    MasterViewController *MasterViewControler = [[MasterViewController alloc] init];
    SearchViewController *searchViewController = [[SearchViewController alloc] init];
    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    detailViewController.DEV_KEY = developerKey;
    MasterViewControler.DEV_KEY = developerKey;
    searchViewController.DEV_KEY = developerKey;
    self.masterNavigationController = [[UINavigationController alloc] initWithRootViewController:MasterViewControler];
    self.searchNavigationController = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    UITabBarController *tabBarController = [[UITabBarController alloc] init]; //Create TabBar with two NavigationController.
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
    [tabBarController setViewControllers:@[self.masterNavigationController, self.searchNavigationController]];
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
