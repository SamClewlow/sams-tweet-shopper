//
//  STSearchResultTableViewCell.h
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 02/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STSSearchResultTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UITextView *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end
