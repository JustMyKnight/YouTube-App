//
//  DetailViewController.h
//  YouTubeAPP
//
//  Created by Admin on 21.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YouTubeVideo;

@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *PublishedAt;
@property (weak, nonatomic) IBOutlet UILabel *Title;
@property (weak, nonatomic) IBOutlet UILabel *view_counts;
@property (weak, nonatomic) IBOutlet UILabel *like;
@property (weak, nonatomic) IBOutlet UILabel *dislike;
@property (retain, nonatomic) NSString *DEV_KEY;
@property (strong, nonatomic) YouTubeVideo *selectedVideo;
@property (strong, nonatomic) DetailViewController *DetailViewController;
@property (weak, nonatomic) IBOutlet UILabel *descript;
@property (weak, nonatomic) IBOutlet UILabel *duration;
@end

