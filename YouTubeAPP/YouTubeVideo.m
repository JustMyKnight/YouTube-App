//
//  YouTubeVideo.m
//  YouTube-App
//
//  Created by Admin on 21.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//
#import "YouTubeVideo.h"

@implementation YouTubeVideo

- (id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.Description = [aDecoder decodeObjectForKey:@"Description"];
        self.previewUrl = [aDecoder decodeObjectForKey:@"previewUrl"];
        self.videoID = [aDecoder decodeObjectForKey:@"videoID"];
        self.published = [aDecoder decodeObjectForKey:@"published"];
        self.duration = [aDecoder decodeObjectForKey:@"duration"];
        self.viewsCount = [aDecoder decodeObjectForKey:@"viewsCount"];
        self.likesCount = [aDecoder decodeObjectForKey:@"likesCount"];
        self.dislikesCount = [aDecoder decodeObjectForKey:@"dislikesCount"];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_Description forKey:@"Description"];
    [aCoder encodeObject:_previewUrl forKey:@"previewUrl"];
    [aCoder encodeObject:_videoID forKey:@"videoID"];
    [aCoder encodeObject:_published forKey:@"published"];
    [aCoder encodeObject:_duration forKey:@"duration"];
    [aCoder encodeObject:_viewsCount forKey:@"viewsCount"];
    [aCoder encodeObject:_likesCount forKey:@"likesCount"];
    [aCoder encodeObject:_dislikesCount forKey:@"dislikesCount"];
}

@end
