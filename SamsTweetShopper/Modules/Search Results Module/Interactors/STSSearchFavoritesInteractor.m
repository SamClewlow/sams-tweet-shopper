//
//  STSSearchFavoritesInteractor.m
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 02/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import "STSSearchFavoritesInteractor.h"
@import CoreData;


// Models
#import "STSSearchResultTweet.h"
#import "STSManagedFavouriteTweet.h"

// Managers
#import "STSCoreDataManager.h"


#pragma mark - Interface

@interface STSSearchFavoritesInteractor() <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *favoritesFetchedResultsController;

@end


#pragma mark - Implementation

@implementation STSSearchFavoritesInteractor


#pragma mark - STSSearchFavoritesInteractorInterface

- (void)addSearchResultTweetToFavorites:(STSSearchResultTweet *)searchResultTweet {
    
    STSManagedFavouriteTweet *favoriteTweet = [[STSCoreDataManager sharedInstance] newFavoriteTweet];
    
    favoriteTweet.statusBody = searchResultTweet.statusBody;
    favoriteTweet.avatarURL = searchResultTweet.avatarURL;
    favoriteTweet.screenName = searchResultTweet.screenName;
    favoriteTweet.tweetId = searchResultTweet.tweetID;
    favoriteTweet.createdAt = searchResultTweet.createdAtDate;
    
    [[STSCoreDataManager sharedInstance] save];
    
}

- (void)removeSearchResultTweetFromFavorites:(STSSearchResultTweet *)searchResultTweet {
    
    NSPredicate *tweetIdPredicate = [NSPredicate predicateWithFormat:@"tweetId == %@", searchResultTweet.tweetID];
    
    [[STSCoreDataManager sharedInstance] deleteObjectsMatchingPredicate:tweetIdPredicate];
    
    [[STSCoreDataManager sharedInstance] save];
}


- (BOOL)isSearchResultTweetAFavorite:(STSSearchResultTweet *)searchResultTweet {
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(STSManagedFavouriteTweet *tweet, NSDictionary *bindings) {
        if ([tweet.tweetId isEqualToString:searchResultTweet.tweetID]) {
            return YES;
        } else {
            return NO;
        }
    }];
    
    if ([self.favoritesFetchedResultsController.fetchedObjects filteredArrayUsingPredicate:predicate].count > 0) {
        return YES;
    } else {
        return NO;
    }
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
