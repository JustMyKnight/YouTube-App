//
//  MasterViewController.m
//  YouTubeAPP
//
//  Created by Admin on 21.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "MasterViewController.h"
#import "CustomVideoCell.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "YouTubeVideo.h"
#import "DetailViewController.h"
#import "SearchViewController.h"

@interface MasterViewController ()<UITableViewDelegate,
UITableViewDataSource>

@property (retain, nonatomic) NSDictionary *videoListJSON;
@property (strong, nonatomic) NSMutableArray *videoList;
@property (weak, nonatomic) IBOutlet UITableView *videoTableView;
@end

@implementation MasterViewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.videoTableView.delegate = self;
    self.videoTableView.dataSource = self;
    self.videoList = [[NSMutableArray alloc] init];
    self.navigationItem.title = @"Популярные видео";
    [self getVideoList];
}
//get list of video from youtube Popular chanel using Youtube api v3
- (void)getVideoList
{
    self.videoTableView.hidden=NO;
    NSString *playlistID = @"PLgMaGEI-ZiiZ0ZvUtduoDRVXcU5ELjPcI";
    NSString *maxResults = @"30";
    NSString *urlString = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/playlistItems?part=snippet%%2CcontentDetails&maxResults=%@&playlistId=%@&fields=items%%2Fsnippet&key=%@", maxResults, playlistID, self.DEV_KEY];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer]; //parsering JSON Data from recieved page
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         self.videoListJSON = (NSDictionary *)responseObject;
         NSDictionary *items = [responseObject objectForKey:@"items"];
         for (NSDictionary *item in items )
         {
             YouTubeVideo *youTubeVideo = [[YouTubeVideo alloc] init];
             NSDictionary* snippet = [item objectForKey:@"snippet"];
             youTubeVideo.title = [snippet objectForKey:@"title"];
             youTubeVideo.videoID = [[snippet objectForKey:@"resourceId"]objectForKey:@"videoId"];
             youTubeVideo.previewUrl = [[[snippet objectForKey:@"thumbnails"] objectForKey:@"medium"] objectForKey:@"url"];
             youTubeVideo.published =[snippet objectForKey:@"publishedAt"];
             youTubeVideo.published=[youTubeVideo.published substringWithRange:NSMakeRange(0, [youTubeVideo.published length]-14)];             
             [self.videoList addObject:youTubeVideo];
         }
    [self.videoTableView reloadData]; //ReloadData in table, when connection established
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connection!!"
                                                             message:[error localizedDescription]
                                                            delegate:nil
                                                   cancelButtonTitle:@"Ok"
                                                   otherButtonTitles:nil];
         [alertView show];
     }];
    
    [operation start];    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.videoList count];
}

//custom cell for main table
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    CustomVideoCell *cell = (CustomVideoCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomVideoCell"owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    YouTubeVideo *youTubeVideo = self.videoList[indexPath.row];
    [cell.previewImage setImageWithURL: [NSURL URLWithString: youTubeVideo.previewUrl]];
    [cell.title setText:youTubeVideo.title];
    [cell.PubledAt setText:youTubeVideo.published];
    return cell;
}

//open detail video description when user select table row
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.DetailViewController = nil;
    self.DetailViewController = [[DetailViewController alloc] initWithTag:1];
    self.DetailViewController.selectedVideo = self.videoList[indexPath.row];
    [self.navigationController pushViewController:self.DetailViewController animated:YES];
}

@end