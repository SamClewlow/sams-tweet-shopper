//
//  STSFavoritesDataInteractor.m
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 03/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import "STSFavoritesDataInteractor.h"
@import CoreData;

// Services
#import "STSCoreDataManager.h"


#pragma mark - Interface

@interface STSFavoritesDataInteractor()<NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *favoritesFetchedResultsController;

@end


#pragma mark - Implementation

@implementation STSFavoritesDataInteractor


#pragma mark - STSFavoritesDataInteractorInterface

- (NSArray *)getManagedFavoriteDataObjects {
    
    return self.favoritesFetchedResultsController.fetchedObjects;
}

- (void)deleteFavoriteTweet:(STSManagedFavouriteTweet *)favoriteTweet {
    
    [[STSCoreDataManager sharedInstance] deleteObject:favoriteTweet];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    NSLog(@"");
}


#pragma mark - Lazy Properties

- (NSFetchedResultsController *)favoritesFetchedResultsController {
    
    if (_favoritesFetchedResultsController == nil) {
        
        _favoritesFetchedResultsController = [[STSCoreDataManager sharedInstance] favoritesFetchedResultsController];
        [_favoritesFetchedResultsController performFetch:NULL];
        _favoritesFetchedResultsController.delegate = self;
    }
    
    return _favoritesFetchedResultsController;
}

@end
