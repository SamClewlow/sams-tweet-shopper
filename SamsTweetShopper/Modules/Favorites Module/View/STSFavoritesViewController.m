//
//  STSFavoritesViewController.m
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 02/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import "STSFavoritesViewController.h"

// Views
#import "STSSearchResultTableViewCell.h"

// Model
#import "STSSearchResultViewModel.h"

// Service
#import "SCImageCacheService.h"


#pragma mark - Interface

@interface STSFavoritesViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *favoritesArray;

@end


#pragma mark - Implementation

@implementation STSFavoritesViewController


#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.eventHandler viewWasDisplayed];
}


#pragma mark - View Setup

- (void)setupViews {
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([STSSearchResultTableViewCell class])
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:NSStringFromClass([STSSearchResultTableViewCell class])];
    
    // Enable auto cell sizing with autolayout
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;
    
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;

    // Create an action to remove from favorites
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                    title:@"Un-Favorite!"
                                                  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                      
                                                      // Notify the event handler
                                                      [weakSelf.eventHandler userDidSelectUnFavoriteAtIndex:indexPath.row];
                                                  }];
    
    return @[action];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.favoritesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Dequeue a cell
    STSSearchResultTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([STSSearchResultTableViewCell class])
                                                                              forIndexPath:indexPath];
    
    STSSearchResultViewModel *viewModel = self.favoritesArray[indexPath.row];
    
    // Set the tweet text
    cell.tweetLabel.text = viewModel.resultContent;
    
    // Set the screen name
    cell.userNameLabel.text = viewModel.screenName;
    
    // Set a default image
    cell.avatarImage.image = [UIImage imageNamed:@"default-user-img"];
    
    cell.contentView.backgroundColor = [UIColor colorWithRed:250.0/255.0
                                                       green:250.0/255.0
                                                        blue:210.0/255
                                                       alpha:0.8];
    
    __weak typeof(self) weakSelf = self;
    
    // Download and cache the avatar image
    [[SCImageCacheService sharedInstance] getImageForURL:viewModel.imageURL
                                       requestIdentifier:[indexPath description] completionHandler:^(UIImage *image, NSString *imageURL, NSError *error) {
                                           
                                           // Get a ref to the cell for the appropirate index path, as the
                                           // cell object may have been recycled
                                           STSSearchResultTableViewCell *weakCell = (STSSearchResultTableViewCell *)[weakSelf.tableView cellForRowAtIndexPath:indexPath];
                                           
                                           NSLog(@"image = %@, cell %@", image, weakCell);
                                           
                                           if (image != nil) {
                                               
                                               weakCell.avatarImage.image = image;
                                               
                                           } else {
                                               
                                               // Set a default
                                               weakCell.avatarImage.image = [UIImage imageNamed:@"default-user-img"];
                                           }
                                           
                                       }];
    return cell;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Required for favorite edit action
}

#pragma mark - STSFavoritesViewInterace

- (void)presentFavoriteTweets:(NSArray *)favorites {
    
    self.favoritesArray = favorites;
    [self.tableView reloadData];
}

- (void)updateFavoriteTweets:(NSArray *)favorites
                deleteIndexs:(NSIndexSet *)indexSet {
    
    self.favoritesArray = favorites;
    
    // Loop through and convert the indexes to index paths 
    if (indexSet != nil) {
        
        __block NSMutableArray *indexPaths = [NSMutableArray new];
        
        [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            [indexPaths addObject:indexPath];
        }];
        
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
    }
}

@end
