//
//  SearchVideoCell.h
//  YouTubeAPP
//
//  Created by Oleg Sulyanov on 25/05/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

//Create custom cell for search controller
#import <UIKit/UIKit.h>

@interface SearchVideoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *previewImage;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *PubledAt;
@end
