//
//  DetailViewController.m
//  YouTubeAPP
//
//  Created by Admin on 21.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "DetailViewController.h"
#import "YTPlayerView.h"
#import "YouTubeVideo.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "MasterViewController.h"
#import "AppDelegate.h"

@interface DetailViewController ()
@property (retain, nonatomic) NSDictionary *videoListJSON;
@property (strong, nonatomic) NSMutableArray *videoList;
@property (weak, nonatomic) IBOutlet UILabel *Published;
@property (weak, nonatomic) IBOutlet UIView *tallMpContainer;
@property (weak, nonatomic) IBOutlet YTPlayerView *youTubePlayer;
@property (weak, nonatomic) IBOutlet UITableView *videoTableView;
@property (strong, nonatomic) IBOutlet UITabBar *TabBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *Main;
@end

@implementation DetailViewController

- (void)TabBar:(UITabBar *)TabBar didSelectItem:(UITabBarItem *)item
{
    if(item.tag == 0)
    {NSLog(@"0");
    }
    if(item.tag == 1)
    {NSLog(@"1");
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Назад"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(back)];        
        [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
        
    }
   
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown:)];
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)];
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setScreenWithDeviceOrientation:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.youTubePlayer addGestureRecognizer:swipeDown];
    [self.youTubePlayer addGestureRecognizer:swipeUp];
    [self.youTubePlayer addGestureRecognizer:swipeLeft];
}

-(void)setScreenWithDeviceOrientation:(NSNotification *)notification
{ CGRect tallContainerFrame, YouTubeVideoFrame;
    CGFloat tallContainerAlpha;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat mpWidth = screenRect.size.width;
    CGFloat mpHeight = screenRect.size.height;
    UIDeviceOrientation orientation=[[UIDevice currentDevice] orientation];
    if(orientation==UIInterfaceOrientationPortrait)  //Portrait orientation
    {
        NSArray* array =[self.navigationController viewControllers];
        if (array[0]==0)
        {
            CGFloat mpWidth = 160;
            CGFloat mpHeight = 90;
            CGFloat x = self.view.bounds.size.width-mpWidth;
            CGFloat y = self.view.bounds.size.height-mpHeight;
            YouTubeVideoFrame = CGRectMake(x, y-51, mpWidth, mpHeight);
            self.youTubePlayer.frame = YouTubeVideoFrame;
            
        }
        else
        {
        YouTubeVideoFrame = CGRectMake(0, 70, self.view.bounds.size.width, 180);
        self.youTubePlayer.frame = YouTubeVideoFrame;
        tallContainerFrame = CGRectMake(2, 253, self.view.bounds.size.width, 500);
        self.tallMpContainer.frame = tallContainerFrame;
        tallContainerAlpha = 1.0;
        self.tallMpContainer.alpha = tallContainerAlpha;
        self.TabBar.hidden = NO;
        }
    }
    
    else if(orientation==UIInterfaceOrientationLandscapeLeft)
    {
        YouTubeVideoFrame = CGRectMake(0, 0, mpWidth, mpHeight);
        self.youTubePlayer.frame = YouTubeVideoFrame;
        self.TabBar.hidden = YES;
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
    }
    else if(orientation==UIInterfaceOrientationLandscapeRight)  //landscape Right
    {
       
        YouTubeVideoFrame = CGRectMake(0, 0, mpWidth, mpHeight);
        self.youTubePlayer.frame = YouTubeVideoFrame;
        self.TabBar.hidden = YES;
    }
}

- (BOOL)mpIsMinimized {
    return self.youTubePlayer.frame.origin.y < 100;
}

- (void)swipeDown:(UIGestureRecognizer *)gr {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.window addSubview:self.youTubePlayer];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self minimizeMp:YES animated:YES];
}

- (void)swipeUp:(UIGestureRecognizer *)gr {
    DetailViewController *test = [[DetailViewController alloc] init];
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:test animated:YES completion:nil];
    // DetailViewController *test = [[DetailViewController alloc] init];
    //[self presentViewController:test animated:YES completion:nil];
    [self minimizeMp:NO animated:YES];
}

- (void)swipeLeft:(UIGestureRecognizer *)gr {
    if ([self mpIsMinimized])
        return;
    [self.youTubePlayer stopVideo];
    CGRect playerFrame = self.youTubePlayer.frame;
    playerFrame.origin.x = -self.youTubePlayer.frame.size.width;
    [UIView animateWithDuration:0.5 animations:^{
    self.youTubePlayer.frame = playerFrame;
    self.youTubePlayer.alpha= 0;
    }];
    
    
}

- (void)minimizeMp:(BOOL)minimized animated:(BOOL)animated 
{
    CGRect tallContainerFrame, YouTubeVideoFrame;
    CGFloat tallContainerAlpha;
    UIDeviceOrientation orientation=[[UIDevice currentDevice] orientation];
    
    if (orientation==UIInterfaceOrientationPortrait)
    {
    if (minimized)
        {
        CGFloat mpWidth = self.youTubePlayer.frame.size.width / 2;
        CGFloat mpHeight = self.youTubePlayer.frame.size.height / 2;
        CGFloat x = self.view.bounds.size.width-mpWidth;
        CGFloat y = self.view.bounds.size.height-mpHeight;
        tallContainerFrame = CGRectMake(x, y, 150, self.view.bounds.size.height);
        YouTubeVideoFrame = CGRectMake(x, y-51, mpWidth, mpHeight);
        tallContainerAlpha = 0.0;
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
        }
    else
        {
        tallContainerFrame = CGRectMake(2, 253, self.view.bounds.size.width, 500);
        YouTubeVideoFrame = CGRectMake(0, 70, self.view.bounds.size.width, 180);
        tallContainerAlpha = 1.0;
        }
    NSTimeInterval duration = (animated)? 0.5 : 0.0;
    [UIView animateWithDuration:duration animations:^{
    self.youTubePlayer.frame = YouTubeVideoFrame;
    self.tallMpContainer.frame = tallContainerFrame;
    self.tallMpContainer.alpha = tallContainerAlpha;
    }];
    if ([self mpIsMinimized] == minimized) return;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{self.youTubePlayer.hidden = NO;
    self.youTubePlayer.alpha= 1;
    CGRect YouTubeVideoFrame, tallContainerFrame;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat mpWidth = screenRect.size.width;
    CGFloat mpHeight = screenRect.size.height;
    
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        NSLog(@"Height: %f",mpHeight);
        NSLog(@"Widht: %f",mpWidth);
        YouTubeVideoFrame = CGRectMake(0, 0, mpWidth, mpHeight);
        self.youTubePlayer.frame = YouTubeVideoFrame;
        self.TabBar.hidden = YES;
    }
    else
    {
        tallContainerFrame = CGRectMake(2, 253, mpWidth, 500);
        self.tallMpContainer.frame = tallContainerFrame;
        self.tallMpContainer.alpha = 1.0;
        YouTubeVideoFrame = CGRectMake(0,70, mpWidth, 180);
        self.youTubePlayer.frame = YouTubeVideoFrame;
        self.TabBar.hidden = NO;
    }
    NSString *urlString = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/videos?part=id%%2C+snippet%%2C+contentDetails%%2C+statistics&id=%@&key=AIzaSyAUax-Gjc6Dlech0E0hXsR30WKX2i5TGtA", self.selectedVideo.videoID];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         self.videoListJSON = (NSDictionary *)responseObject;
         NSDictionary *items = [responseObject objectForKey:@"items"];
         for (NSDictionary *item in items )
         {
             YouTubeVideo *youTubeVideo = [[YouTubeVideo alloc] init];
             NSDictionary* snippet = [item objectForKey:@"snippet"];
             youTubeVideo.title = [snippet objectForKey:@"title"];
             youTubeVideo.Description = [snippet objectForKey:@"description"];
             NSDictionary* statistics = [item objectForKey:@"statistics"];
             youTubeVideo.viewsCount = [statistics objectForKey:@"viewCount"];
             youTubeVideo.likesCount = [statistics objectForKey:@"likeCount"];
             youTubeVideo.dislikesCount = [statistics objectForKey:@"dislikeCount"];
             NSDictionary* contentdetails = [item objectForKey:@"contentDetails"];
             youTubeVideo.duration = [contentdetails objectForKey:@"duration"];
             [self.videoList addObject:youTubeVideo];
             NSDictionary *playerVars = @{@"playsinline" : @1,
                                          @"modestbranding": @1,
                                          @"showinfo": @0,
                                          @"controls": @2,
                                          @"iv_load_policy": @3,
                                          @"rel": @0,
                                          @"theme": @"light",
                                          @"fs":@0,
                                          @"autohide":@0
                                          };
             [self.youTubePlayer loadWithVideoId:self.selectedVideo.videoID playerVars:playerVars];
             [self.youTubePlayer playVideo];
             [self.PublishedAt setText:self.selectedVideo.published];
             [self.Title setText:self.selectedVideo.title];
             [self.view_counts setText:youTubeVideo.viewsCount];
             [self.like setText:youTubeVideo.likesCount];
             [self.dislike setText:youTubeVideo.dislikesCount];
             [self.descript setText: youTubeVideo.Description];
             
             NSMutableString *duration = [NSMutableString stringWithString:youTubeVideo.duration];
             
             NSString *temp = [duration substringFromIndex:2];
             temp = [temp substringToIndex:[temp length] - 1];
             
             duration = [NSMutableString stringWithString: temp];
             int i = 0;
             int length = [duration length];
             while (i<length)
             {
                 char c = [duration characterAtIndex:i];
                 if(!(c>='0' && c<='9'))
                 {
                     NSRange range = {i,1};
                     [duration replaceCharactersInRange:range withString:@":"];
                 }
                 i++;
             }
             self.duration.text = duration;
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {         
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connection"
                                                             message:[error localizedDescription]
                                                            delegate:nil
                                                   cancelButtonTitle:@"Ok"
                                                   otherButtonTitles:nil];
         [alertView show];
     }];
    [operation start];
    [super viewWillAppear:animated];
    
}

- (IBAction)back
{   self.youTubePlayer.hidden = YES;
    [self.navigationController popToRootViewControllerAnimated:YES];}
@end
