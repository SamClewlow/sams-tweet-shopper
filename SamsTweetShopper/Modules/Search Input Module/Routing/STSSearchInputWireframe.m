//
//  STSSearchInputWireframe.m
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 02/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import "STSSearchInputWireframe.h"

// Search Result Module
#import "STSSearchResultsModuleInterface.h"
#import "STSSearchResultsWireframe.h"

// Module component classes
#import "STSSearchInputViewController.h"
#import "STSSearchInputPresenter.h"
#import "STSTwitterAccessInteractor.h"
#import "STSSearchTermValidInteractor.h"

// Constants
#import "STSConstants.h"


#pragma mark - Interface

@interface STSSearchInputWireframe()

@property (nonatomic, strong) STSSearchInputPresenter *presenter;
@property (nonatomic, strong) UINavigationController *rootNavigationController;
@property (nonatomic, strong) id<STSSearchResultsModuleInterface> searchResultsModule;

@end


#pragma mark - Implementation

@implementation STSSearchInputWireframe


#pragma mark - Init

- (instancetype)init {
    
    if (self = [super init]) {
        
        [self setupModule];
    }
    
    return self;
}


#pragma mark - Module Setup

// This where we inject all dependencies for the search input module.

- (void)setupModule {
    
    // Inject the dependencies into the presenter
    self.presenter = [[STSSearchInputPresenter alloc] init];
    self.presenter.wireframe = self;
    
    STSSearchInputViewController *viewController = [self.rootNavigationController.viewControllers firstObject];
    viewController.eventHandler = self.presenter;
    
    self.presenter.userInterface = viewController;
    
    STSTwitterAccessInteractor *twitterInteractor = [[STSTwitterAccessInteractor alloc] init];
    twitterInteractor.presenter = self.presenter;
    self.presenter.twitterAccessInteractor = twitterInteractor;
    
    self.presenter.searchTermValidationInteractor = [[STSSearchTermValidInteractor alloc] init];
}


#pragma mark - STSSearchInputModuleInterface

- (UINavigationController *)getUserInterface {
    
    return self.rootNavigationController;
}

- (void)readyToPerformSearchWithSearchTerm:(NSString *)searchTerm {
    
    // Routing happens here
    [self.searchResultsModule presentResultsForSearchTerm:searchTerm
                                   inNavigationController:self.rootNavigationController];

}

- (void)viewWasPresented {
    
    // Tear down the search results module so it doens't hang in memory
    _searchResultsModule = nil;
    
}

#pragma mark - Lazy Loaded Properties

- (id<STSSearchResultsModuleInterface>)searchResultsModule {
    
    if (_searchResultsModule == nil) {
        
        // This would really benefit from an injection framework, rather than an explicit depenency...
        _searchResultsModule = [[STSSearchResultsWireframe alloc] init];
    }
    
    return _searchResultsModule;
}

- (UINavigationController *)rootNavigationController {
    
    if (_rootNavigationController == nil) {
        
        // Inflate navigation controller for the search module from the story board
        _rootNavigationController = [[UIStoryboard storyboardWithName:@"Main"
                                                               bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:kSTSSearchModuleNavConId];
    }
    
    return _rootNavigationController;
}

@end
