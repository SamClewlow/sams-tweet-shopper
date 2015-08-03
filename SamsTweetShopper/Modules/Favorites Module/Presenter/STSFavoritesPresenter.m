//
//  STSFavoritesPresenter.m
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 02/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import "STSFavoritesPresenter.h"

// Models
#import "STSSearchResultViewModel.h"
#import "STSManagedFavouriteTweet.h"


#pragma mark - Interface

@interface STSFavoritesPresenter()

@property (nonatomic, strong) NSArray *favoriteTweets;

@end


#pragma mark - Implementation

@implementation STSFavoritesPresenter


#pragma mark - STSFavoritesPresenterInterface

- (void)viewWasDisplayed {
    
    self.favoriteTweets = [self.dataInteractor getManagedFavoriteDataObjects];
    [self.userInterface presentFavoriteTweets:[self getViewModelsForDataModels:self.favoriteTweets]];
}

- (void)userDidSelectUnFavoriteAtIndex:(NSInteger)index {
    
    if (index < self.favoriteTweets.count) {
        
        // Delete the tweet requested
        [self.dataInteractor deleteFavoriteTweet:self.favoriteTweets[index]];
        
        // Refresh the models held locally
        self.favoriteTweets = [self.dataInteractor getManagedFavoriteDataObjects];
        
        // Update the UI
        [self.userInterface updateFavoriteTweets:[self getViewModelsForDataModels:self.favoriteTweets]
                                    deleteIndexs:[NSIndexSet indexSetWithIndex:index]];
    }
}


#pragma mark - Internal Helper

- (NSArray *)getViewModelsForDataModels:(NSArray *)dataModels {
    
    NSMutableArray *viewModels = [NSMutableArray new];
    
    for (STSManagedFavouriteTweet *dataModel in dataModels) {
        
        STSSearchResultViewModel *viewModel = [[STSSearchResultViewModel alloc] initWithResultContent:dataModel.statusBody
                                                                                             imageURL:dataModel.avatarURL
                                                                                           screenName:dataModel.screenName
                                                                                           isFavorite:YES];
        
        [viewModels addObject:viewModel];
    }
    
    return [NSArray arrayWithArray:viewModels];
    
}

@end
