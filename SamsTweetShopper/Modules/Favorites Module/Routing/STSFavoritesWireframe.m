//
//  STSFavoritesWireframe.m
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 02/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import "STSFavoritesWireframe.h"

// Classes
#import "STSFavoritesViewController.h"
#import "STSFavoritesPresenter.h"
#import "STSFavoritesDataInteractor.h"

// Contsants
#import "STSConstants.h"


#pragma mark - Interface

@interface STSFavoritesWireframe()

@property (nonatomic, strong) STSFavoritesPresenter *presenter;
@property (nonatomic, strong) UINavigationController *rootNavigationController;

@end


#pragma mark - Implementation

@implementation STSFavoritesWireframe

#pragma mark - Init

- (instancetype)init {
    
    if (self = [super init]) {
        
        [self setupModule];
    }
    
    return self;
}


#pragma mark - Module Setup

// This where we inject all dependencies
- (void)setupModule {
    
    // Inject the dependencies into the presenter
    self.presenter = [[STSFavoritesPresenter alloc] init];
    
    STSFavoritesViewController *viewController = (STSFavoritesViewController *)[self.rootNavigationController.viewControllers firstObject];
    viewController.eventHandler = self.presenter;
    
    self.presenter.userInterface = viewController;
    self.presenter.dataInteractor = [[STSFavoritesDataInteractor alloc] init];
    
}


#pragma mark - STSSearchInputModuleInterface

- (UINavigationController *)getUserInterface {
    
    return self.rootNavigationController;
}


#pragma mark - Lazy Loaded Properties

- (UINavigationController *)rootNavigationController {
    
    if (_rootNavigationController == nil) {
        
        // Inflate navigation controller for the search module from the story board
        _rootNavigationController = [[UIStoryboard storyboardWithName:@"Main"
                                                               bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:kSTSFavoritesModuleNavConId];
    }
    
    return _rootNavigationController;
}

@end
