//
//  YouTubeVideo.h
//  YouTube-App
//
//  Created by Admin on 21.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

//Class with YouTube video properties
#import <Foundation/Foundation.h>

@interface YouTubeVideo : NSObject <NSCoding>

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *Description;
@property (strong, nonatomic) NSString *previewUrl;
@property (strong, nonatomic) NSString *videoID;
@property (strong, nonatomic) NSString *published;
@property (strong, nonatomic) NSString *duration;
@property (strong, nonatomic) NSString *viewsCount;
@property (strong, nonatomic) NSString *likesCount;
@property (strong, nonatomic) NSString *dislikesCount;

@end
