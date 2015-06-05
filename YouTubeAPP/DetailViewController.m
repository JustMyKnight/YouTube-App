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
#import "LLARingSpinnerView.h"

@interface DetailViewController ()
@property (retain, nonatomic) NSDictionary *videoListJSON;
@property (strong, nonatomic) NSMutableArray *videoList;
@property (weak, nonatomic) IBOutlet UILabel *Published;
@property (weak, nonatomic) IBOutlet UIView *tallMpContainer;
@property (weak, nonatomic) IBOutlet YTPlayerView *youTubePlayer;
@property (weak, nonatomic) IBOutlet UITableView *videoTableView;
@property (weak, nonatomic) IBOutlet UIImageView *like_img;
@property (weak, nonatomic) IBOutlet UIImageView *dislike_img;
@end

@implementation DetailViewController

- (id) initWithTag:(int) tag //init tag that shows what controller opened detail controller
{
    self=[super init];
    if (self)
    {
        _tag=tag;
    }
    return self;
}

- (void)indicator:(int)MPindicator
{
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    indicator.center = self.view.center;
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    if(MPindicator==1)
    { NSLog(@"%d", MPindicator);
     [indicator startAnimating];
    }
    else
    {
    NSLog(@"%d", MPindicator);
        for (UIView *subView in self.view.subviews)
        {
            if ([subView isKindOfClass:[indicator class]])
            {
                [subView removeFromSuperview];
            }
        }
      }
}
- (void)viewDidLoad
{    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown:)];
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)];
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setScreenWithDeviceOrientation:) name:@"UIDeviceOrientationDidChangeNotification" object:nil]; //activate Notification Center for screen rotation
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.youTubePlayer addGestureRecognizer:swipeDown];
    [self.youTubePlayer addGestureRecognizer:swipeUp];
    [self.youTubePlayer addGestureRecognizer:swipeLeft];
    //[self indicator:1];
    
    [self Videoshow];
    
}

-(void)setScreenWithDeviceOrientation:(NSNotification *)notification //set size of the youtubeplayer for any interface orientation
{
    CGRect YouTubeVideoFrame;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat mpWidth = screenRect.size.width;
    CGFloat mpHeight = screenRect.size.height;
    UIDeviceOrientation orientation=[[UIDevice currentDevice] orientation];
    if(orientation==UIInterfaceOrientationPortrait)  //Portrait orientation
    {
        NSArray* array =[self.navigationController viewControllers];
        if (array[0]==0) //set position and size of the youtubeplayer in portrait orientation, when it was swiped down.
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
        }
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
        [self.tabBarController.tabBar setHidden:NO];
    }
    else //full screen in landscape orientation
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

- (void)swipeDown:(UIGestureRecognizer *)gr { //define swipe down gesture on youtubeplayer
    UIDeviceOrientation orientation=[[UIDevice currentDevice] orientation];
    if(orientation!=UIInterfaceOrientationPortrait) return;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.window addSubview:self.youTubePlayer]; //move youtubeplayer in separate window in the corner
    [self.navigationController popToRootViewControllerAnimated:YES]; //go to root controller of the detail view
    [self minimizeMp:YES animated:YES];
}

- (void)swipeUp:(UIGestureRecognizer *)gr { //define swipe up gesture on youtubeplayer
    [UIView animateWithDuration:0.5 animations:^{
    [self minimizeMp:NO animated:YES];
    }];
}

- (void)swipeLeft:(UIGestureRecognizer *)gr { //define swipe left gesture on youtubeplayer
    if ([self mpIsMinimized]) return;
    [self.youTubePlayer stopVideo]; //stop video, when youtubeplayer was moved
    CGRect playerFrame = self.youTubePlayer.frame;
    playerFrame.origin.x = -self.youTubePlayer.frame.size.width;
    [UIView animateWithDuration:0.5 animations:^{ //create animation of disappearance when youtubeplayer is moving.
        self.youTubePlayer.frame = playerFrame;
        self.youTubePlayer.alpha= 0;
        }];
}

- (void)minimizeMp:(BOOL)minimized animated:(BOOL)animated //operation with youtubeplayer when user swipe it down or up
{
    if (![self mpIsMinimized] == minimized) return;
    CGRect YouTubeVideoFrame;
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
            YouTubeVideoFrame = CGRectMake(x, y-51, mpWidth, mpHeight);
            tallContainerAlpha = 0.0;
            [[self navigationController] setNavigationBarHidden:NO animated:YES];
        }
        else //open detail view after swipe up youtubeplayer
        {
            __strong UIView* v = self.youTubePlayer;
            [self.youTubePlayer removeFromSuperview];
            [self.view addSubview:v];
            if (self.navigationController == nil)
            {
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                if (self.tag==1)
                    {
                        [appDelegate.masterNavigationController pushViewController:self animated:YES];
                    }
                else
                    {
                        [appDelegate.searchNavigationController pushViewController:self animated:YES];
                    }
            }
            YouTubeVideoFrame = CGRectMake(0, 70, self.view.bounds.size.width, 180);
            tallContainerAlpha = 1.0;
        }
        NSTimeInterval duration = (animated)? 0.5 : 0.0;
        [UIView animateWithDuration:duration animations:^{
            self.youTubePlayer.frame = YouTubeVideoFrame;
            self.tallMpContainer.alpha = tallContainerAlpha;
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) Videoshow //get info about video using YouTubeApi v3
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat mpWidth = screenRect.size.width;
    CGFloat mpHeight = screenRect.size.height;
    NSLog(@"%f", mpHeight/2);
    NSLog(@"%f", mpWidth/2);
    LLARingSpinnerView *spinnerView = [[LLARingSpinnerView alloc] initWithFrame:CGRectMake(mpWidth/2-25, mpHeight/2-25, 30, 30)];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.window addSubview:spinnerView];
    spinnerView.lineWidth = 1.0f;
    spinnerView.tintColor = [UIColor redColor];
    
    [spinnerView startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //sleep(2);
        
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
                                          @"controls": @1,
                                          @"iv_load_policy": @3,
                                          @"rel": @0,
                                          @"theme": @"light",
                                          @"fs":@0,
                                          @"autohide":@0
                                          };
            
             [self.youTubePlayer loadWithVideoId:self.selectedVideo.videoID playerVars:playerVars];
             [self.youTubePlayer playVideo];
             [self.PublishedAt setText:[NSString stringWithFormat:@"Опубликовано: %@",self.selectedVideo.published]];
             [self.Title setText:self.selectedVideo.title];
             [self.view_counts setText:[NSString stringWithFormat:@"Просмотров: %@", youTubeVideo.viewsCount]];
             [self.like setText:youTubeVideo.likesCount];
             [self.dislike setText:youTubeVideo.dislikesCount];
             [self.descript setText: youTubeVideo.Description];
             NSMutableString *duration = [NSMutableString stringWithString:youTubeVideo.duration]; //convert duration time from API to readable view
             NSString *temp = [duration substringFromIndex:2];
             temp = [temp substringToIndex:[temp length] - 1];
             duration = [NSMutableString stringWithString: temp];
             int i = 0;
             int length = (int)[duration length];
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
             [self.duration setText:[NSString stringWithFormat:@"Продолжительность: %@", duration]];
             self.dislike_img.hidden=NO;
             self.like_img.hidden=NO;
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
        dispatch_async(dispatch_get_main_queue(), ^{
            sleep(5);
            [spinnerView removeFromSuperview];
        });
    });
}

- (void)viewWillAppear:(BOOL)animated //operation with video when detail view was opened
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    for (UIView *subView in appDelegate.window.subviews)
    {
        if ([subView isKindOfClass:[self.youTubePlayer class]])
        {
            [subView removeFromSuperview];
        }
    }
    CGRect YouTubeVideoFrame;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat mpWidth = screenRect.size.width;
    CGFloat mpHeight = screenRect.size.height;
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        YouTubeVideoFrame = CGRectMake(0, 0, mpWidth, mpHeight);
        self.youTubePlayer.frame = YouTubeVideoFrame;
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
        [self.tabBarController.tabBar setHidden:YES];
    }
        [super viewWillAppear:animated];
}

//clear memory
- (void) dealloc {
    [self.youTubePlayer removeFromSuperview];
}

@end
