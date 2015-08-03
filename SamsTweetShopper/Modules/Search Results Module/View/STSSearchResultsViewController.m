//
//  STSSearchResultsViewController.m
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 02/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import "STSSearchResultsViewController.h"

// View Model
#import "STSSearchResultViewModel.h"

// Cells
#import "STSSearchResultTableViewCell.h"

// Shared Service
#import "SCImageCacheService.h"


// Internal constants
CGFloat const kLoadingSpinnerBorderWidth = 20.0;


#pragma mark - Interface

@interface STSSearchResultsViewController ()<UITableViewDataSource, UITableViewDelegate>

// An array of STSSearchResultViewModel
@property (nonatomic, strong) NSArray *searchResults;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIView *activityIndicatorContainer;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


#pragma mark - Implementation

@implementation STSSearchResultsViewController


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
    
    self.activityIndicatorContainer.layer.cornerRadius = kLoadingSpinnerBorderWidth;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([STSSearchResultTableViewCell class]) bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:NSStringFromClass([STSSearchResultTableViewCell class])];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;
    
}


#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    
    STSSearchResultViewModel *viewModel = self.searchResults[indexPath.row];
    
    UITableViewRowAction *action = nil;
    
    if (!viewModel.isFavorite) {
        
        action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                    title:@"Favorite!"
                                                  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                      
                                                      // Notify the event handler
                                                      [weakSelf.eventHandler userDidSelectFavoriteAtIndex:indexPath.row];
                                                  }];
    } else {
        
        action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                    title:@"Un-Favorite!"
                                                  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {

                                                      // Notify the event handler
                                                      [weakSelf.eventHandler userDidSelectUnFavoriteAtIndex:indexPath.row];
                                                  }];
    }
    
    return @[action];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Dequeue a cell
    STSSearchResultTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([STSSearchResultTableViewCell class])
                                                                              forIndexPath:indexPath];
    
    STSSearchResultViewModel *viewModel = self.searchResults[indexPath.row];
    
    // Set the tweet text
    // Workaround for http link detection bug
    cell.tweetLabel.text = nil;
    cell.tweetLabel.text = viewModel.resultContent;
    
    // Set the screen name
    cell.userNameLabel.text = viewModel.screenName;
    
    // Set a default image
    cell.avatarImage.image = [UIImage imageNamed:@"default-user-img"];
    
    if (viewModel.isFavorite) {
        cell.contentView.backgroundColor = [UIColor colorWithRed:250.0/255.0
                                                           green:250.0/255.0
                                                            blue:210.0/255
                                                           alpha:0.8];
    } else {
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
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


#pragma mark - STSSearchResultsViewInterface

- (void)showLoadingState:(BOOL)show {
 
    self.activityIndicatorContainer.hidden = !show;
    
    if (show) {
        [self.activityIndicator startAnimating];
    } else {
        [self.activityIndicator stopAnimating];
    }
}

- (void)showErrorMessage:(NSString *)errorMessage {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                    message:errorMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
}

- (void)presentSearchResults:(NSArray *)searchResults {
    
    self.searchResults = searchResults;
    [self.tableView reloadData];
}

- (void)updateSearchResults:(NSArray *)searchResults
            reloadingIndexs:(NSIndexSet *)indexSet {
    
    self.searchResults = searchResults;
    
    if (indexSet != nil) {
        
        __block NSMutableArray *indexPaths = [NSMutableArray new];
        
        [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            [indexPaths addObject:indexPath];
        }];
        
        [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
