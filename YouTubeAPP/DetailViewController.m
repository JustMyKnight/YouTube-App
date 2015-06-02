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
@property (weak, nonatomic) IBOutlet UITabBarItem *Main;
@end

@implementation DetailViewController

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
        }
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
        [self.tabBarController.tabBar setHidden:NO];
    }
    
    else if(orientation==UIInterfaceOrientationLandscapeLeft)
    {
        YouTubeVideoFrame = CGRectMake(0, 0, mpWidth, mpHeight);
        self.youTubePlayer.frame = YouTubeVideoFrame;
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
        [self.tabBarController.tabBar setHidden:YES];
    }
    else if(orientation==UIInterfaceOrientationLandscapeRight)
    {
        YouTubeVideoFrame = CGRectMake(0, 0, mpWidth, mpHeight);
        self.youTubePlayer.frame = YouTubeVideoFrame;
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
        [self.tabBarController.tabBar setHidden:YES];
    }
}

- (BOOL)mpIsMinimized
{
    return self.youTubePlayer.frame.origin.y < 100;
}

- (void)swipeDown:(UIGestureRecognizer *)gr {
    NSLog(@"Before: %@", [[self navigationController] viewControllers]);
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.window addSubview:self.youTubePlayer];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self minimizeMp:YES animated:YES];
    NSLog(@"After: %@", [[self navigationController] viewControllers]);
}

- (void)swipeUp:(UIGestureRecognizer *)gr {
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
        for (UIView *view in [self.youTubePlayer subviews])
        {
            [view removeFromSuperview];
        }
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
            __strong UIView* v = self.youTubePlayer;
            [self.youTubePlayer removeFromSuperview];
            [self.view addSubview:v];
            [self.view bringSubviewToFront:v];
            NSLog(@"Self.navigation controller: %@", self.navigationController);
            if (self.navigationController == nil) {
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [appDelegate.masterNavigationController pushViewController:self animated:NO];
                NSLog(@"After1: %@", [appDelegate.masterNavigationController viewControllers]);
            }
            
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
       // if ([self mpIsMinimized] == minimized) return;
    }
    NSLog(@"%@", NSStringFromCGRect(self.youTubePlayer.frame));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) Videoshow
{
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
}

- (void)viewWillAppear:(BOOL)animated
{
    CGRect YouTubeVideoFrame;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat mpWidth = screenRect.size.width;
    CGFloat mpHeight = screenRect.size.height;
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        NSLog(@"Height: %f",mpHeight);
        NSLog(@"Widht: %f",mpWidth);
        YouTubeVideoFrame = CGRectMake(0, 0, mpWidth, mpHeight);
        self.youTubePlayer.frame = YouTubeVideoFrame;
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
        [self.tabBarController.tabBar setHidden:YES];
    }
    [self Videoshow];
    [super viewWillAppear:animated];
}

- (IBAction)back
{
    self.youTubePlayer.hidden = YES;
    [[self navigationController] popToRootViewControllerAnimated:YES];
}

- (void) dealloc {
    [self.youTubePlayer removeFromSuperview];
}
@end
