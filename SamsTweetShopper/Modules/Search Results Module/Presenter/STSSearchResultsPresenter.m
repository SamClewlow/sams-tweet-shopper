//
//  STSSearchResultsPresenter.m
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 02/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import "STSSearchResultsPresenter.h"

// Model Objects
#import "STSSearchResultTweet.h"
#import "STSSearchResultViewModel.h"


#pragma mark - Interface

@interface STSSearchResultsPresenter()

@property (nonatomic, strong) NSString *searchTerm;
@property (nonatomic, strong) NSArray *searchResultDataItems;

@end


#pragma mark - Implementation

@implementation STSSearchResultsPresenter


#pragma mark - STSSearchResultsPresenterInterface

// Wireframe
- (void)setSearchTerm:(NSString *)searchTerm {
    
    _searchTerm = [searchTerm copy];
}

// View
- (void)viewWasDisplayed {

    [self.userInterface showLoadingState:YES];

    __weak typeof(self) weakSelf = self;
    
    [self.twitterSearchInteractor performSearchForSearchTerm:self.searchTerm completion:^(NSArray *results, NSError *error) {
       
        [weakSelf.userInterface showLoadingState:NO];
        
        if (results.count > 0) {
            
            // Save the results
            weakSelf.searchResultDataItems = results;
            
            // We got results, convert data model domain objects into view model domain objects
            [weakSelf.userInterface presentSearchResults:[weakSelf viewModelsForDataModels:results]];
            
        } else if (error != nil) {
            
            // Apologies here for very crude error handling. Was too tight on time
            [weakSelf.userInterface showErrorMessage:@"Error With Search!"];
            
        } else {
            
            [weakSelf.userInterface showErrorMessage:@"No Results for your query"];
        }
    }];
}


- (void)userDidSelectFavoriteAtIndex:(NSInteger)index {
    
    if (index < self.searchResultDataItems.count) {
        
        [self.favouritesInteractor addSearchResultTweetToFavorites:self.searchResultDataItems[index]];
        [self.userInterface updateSearchResults:[self viewModelsForDataModels:self.searchResultDataItems]
                                reloadingIndexs:[NSIndexSet indexSetWithIndex:index]];
        
    }
}

- (void)userDidSelectUnFavoriteAtIndex:(NSInteger)index {
    
    if (index < self.searchResultDataItems.count) {
        
        [self.favouritesInteractor removeSearchResultTweetFromFavorites:self.searchResultDataItems[index]];
        [self.userInterface updateSearchResults:[self viewModelsForDataModels:self.searchResultDataItems]
                                reloadingIndexs:[NSIndexSet indexSetWithIndex:index]];
        
    }
}


#pragma mark - View Model Generation

// Generate the view models from the data models. Avoid having mutable data models
// in the view controller. Also separates concerns nicely
- (NSArray *)viewModelsForDataModels:(NSArray *)dataModels {
    
    NSMutableArray *viewModels = [NSMutableArray new];
    
    for (STSSearchResultTweet *dataModel in dataModels) {
        
        STSSearchResultViewModel *viewModel = [[STSSearchResultViewModel alloc] initWithResultContent:dataModel.statusBody
                                                                                             imageURL:dataModel.avatarURL
                                                                                           screenName:dataModel.screenName
                                                                                           isFavorite:[self.favouritesInteractor isSearchResultTweetAFavorite:dataModel]];
        
        [viewModels addObject:viewModel];
    }
    
    return [NSArray arrayWithArray:viewModels];
}

@end
