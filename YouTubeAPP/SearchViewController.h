//
//  SearchViewController.h
//  YouTubeAPP
//
//  Created by Admin on 21.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface SearchViewController : UIViewController

@property (retain, nonatomic) NSString *DEV_KEY;
@property (strong, nonatomic) DetailViewController *DetailViewController;
@property (strong, nonatomic) UINavigationController *DetailNavigationController;
- (void)getVideoList;

@end