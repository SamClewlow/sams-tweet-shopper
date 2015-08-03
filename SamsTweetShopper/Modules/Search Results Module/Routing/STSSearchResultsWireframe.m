//
//  STSSearchResultsWireframe.m
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 02/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import "STSSearchResultsWireframe.h"

// Constants
#import "STSConstants.h"

// View
#import "STSSearchResultsViewController.h"

// Presenter
#import "STSSearchResultsPresenter.h"

// Interactors
#import "STSTwitterSearchInteractor.h"
#import "STSSearchFavoritesInteractor.h"


#pragma mark - Interface

@interface STSSearchResultsWireframe()

@property (nonatomic, strong) STSSearchResultsPresenter *presenter;
@property (nonatomic, strong) STSSearchResultsViewController *viewController;

@end


#pragma mark - Implementation

@implementation STSSearchResultsWireframe


#pragma mark - Init

- (instancetype)init {
    
    if (self = [super init]) {
        
        [self setupModule];
    }
    
    return self;
}


#pragma mark - STSSearchResultsModuleInterface

- (void)presentResultsForSearchTerm:(NSString *)searchTerm
             inNavigationController:(UINavigationController *)navigationController {
    
    [self.presenter setSearchTerm:searchTerm];
    
    [navigationController pushViewController:self.viewController animated:YES];
}


#pragma mark - Module Setup

// This where we inject all dependencies for the search input module.

- (void)setupModule {
    
    // Inject the dependencies into the presenter
    self.presenter = [[STSSearchResultsPresenter alloc] init];
    self.presenter.wireframe = self;
    
    self.viewController.eventHandler = self.presenter;
    self.presenter.userInterface = self.viewController;
    
    self.presenter.twitterSearchInteractor = [[STSTwitterSearchInteractor alloc] init];
    self.presenter.favouritesInteractor = [[STSSearchFavoritesInteractor alloc] init];
}


#pragma mark - Lazy Loaded Properties

- (STSSearchResultsViewController *)viewController {
    
    if (_viewController == nil) {
        
        // Inflate view controller for the search results
        _viewController = [[UIStoryboard storyboardWithName:@"Main"
                                                     bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:kSTSSearchResultsViewConId];
    }
    
    return _viewController;
}

@end
