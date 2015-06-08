//
//  SearchViewController.m
//  YouTubeAPP
//
//  Created by Admin on 21.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "SearchViewController.h"
#import "CustomVideoCell.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "YouTubeVideo.h"
#import "DetailViewController.h"
#import "MasterViewController.h"
#import "AppDelegate.h"
#import "LLARingSpinnerView.h"

@interface SearchViewController () <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) NSDictionary *videoListJSON;
@property (retain, nonatomic) NSMutableArray *videoList;

@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [self convertButtonTitle:@"Cancel" toTitle:@"Отмена" inView:self.searchBar]; //Add custom title for cancel button in search bar
    [super viewDidLoad];
    self.DetailViewController = [[DetailViewController alloc] init];
    self.DetailNavigationController = [[UINavigationController alloc] initWithRootViewController:self.DetailViewController];
    self.videoList = [[NSMutableArray alloc] init];
    self.searchBar.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.navigationItem.title = @"Поиск";
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView setContentOffset:CGPointZero animated:NO];
}

- (void)convertButtonTitle:(NSString *)from toTitle:(NSString *)to inView:(UIView *)view //custom description of cancel button in search bar
{
    if ([view isKindOfClass:[UIButton class]])
    {
        UIButton *button = (UIButton *)view;
        if ([[button titleForState:UIControlStateNormal] isEqualToString:from])
        {
            [button setTitle:to forState:UIControlStateNormal];
        }
    }
    for (UIView *subview in view.subviews)
    {
        [self convertButtonTitle:from toTitle:to inView:subview];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self getVideoList];
    [self.view endEditing:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
}

//get JSON data for parsering with search string
- (void)getVideoList
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat mpWidth = screenRect.size.width;
    CGFloat mpHeight = screenRect.size.height;
    LLARingSpinnerView *spinnerView = [[LLARingSpinnerView alloc] initWithFrame:CGRectMake(mpWidth/2-25, mpHeight/2-25, 30, 30)];
    [self.view addSubview:spinnerView];
    spinnerView.lineWidth = 1.0f;
    spinnerView.tintColor = [UIColor redColor];
    [spinnerView startAnimating];
    NSString *searchString = [self.searchBar.text stringByReplacingOccurrencesOfString:@" " withString: @"+"]; //replace spaces with '+' in search string
    searchString = [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *maxResults = @"50";
    NSString *urlString = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/search?&part=snippet&q=%@&fields=items(id%%2Csnippet)&maxResults=%@&key=%@", searchString, maxResults, self.DEV_KEY]; //url for obtain JSON data
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         self.videoListJSON = (NSDictionary *)responseObject;
         [self.videoList removeAllObjects];
         NSDictionary *items = [responseObject objectForKey:@"items"];
         for (NSDictionary *item in items )
         {
             YouTubeVideo *youTubeVideo = [[YouTubeVideo alloc] init];
             NSDictionary* snippet = [item objectForKey:@"snippet"];
             youTubeVideo.title = [snippet objectForKey:@"title"];
             youTubeVideo.videoID = [[item objectForKey:@"id"] objectForKey:@"videoId"];
             youTubeVideo.previewUrl = [[[snippet objectForKey:@"thumbnails"] objectForKey:@"high"] objectForKey:@"url"];
             youTubeVideo.published =[snippet objectForKey:@"publishedAt"];
             youTubeVideo.published=[youTubeVideo.published substringWithRange:NSMakeRange(0, [youTubeVideo.published length]-14)];
             [self.videoList addObject:youTubeVideo];
             [spinnerView removeFromSuperview];
             self.tableView.hidden = NO;
         }
         [self.tableView reloadData];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [spinnerView removeFromSuperview];
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connection"
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section //return number of elements in videolist array
{
    return [self.videoList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath //init custom cells for search table
{
    static NSString *cellIdentifier = @"Cell";
    CustomVideoCell *cell = (CustomVideoCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SearchVideoCell"owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    YouTubeVideo *youTubeVideo = self.videoList[indexPath.row];
    [cell.previewImage setImageWithURL: [NSURL URLWithString: youTubeVideo.previewUrl]];
    [cell.title setText:youTubeVideo.title];
    [cell.PubledAt setText:youTubeVideo.published];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath //move to detail controller from search
{
    self.DetailViewController = nil;
    self.DetailViewController = [[DetailViewController alloc] initWithTag:0];
    self.DetailViewController.selectedVideo = self.videoList[indexPath.row];
    [self.navigationController pushViewController:self.DetailViewController animated:YES];
}

@end
