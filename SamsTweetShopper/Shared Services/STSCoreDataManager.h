//
//  STSCoreDataManager.h
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 03/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import <Foundation/Foundation.h>

@class STSManagedFavouriteTweet;
@class NSFetchedResultsController;

@interface STSCoreDataManager : NSObject

/**
 *  Returns a new managed instance of STSManagedFavouriteTweet.
 *
 *  @return A new managed instance of STSManagedFavouriteTweet.
 */
- (STSManagedFavouriteTweet *)newFavoriteTweet;

/**
 *  Fetch an array of STSManagedFavouriteTweet items, sorted as desdribed.
 *
 *  @param predicate       A predicate for the fetch
 *  @param sortDescriptors An array of sort descriptors
 *  @param completion      A block to run on completion
 */
- (void)fetchEntriesWithPredicate:(NSPredicate *)predicate
                  sortDescriptors:(NSArray *)sortDescriptors
                       completion:(void (^)(NSArray *results))completion;

/**
 *  Delete a single tweet object
 *
 *  @param tweetObject The tweet object to delete
 */
- (void)deleteObject:(STSManagedFavouriteTweet *)tweetObject;


/**
 *  Deletes the objects matching the predicate
 *
 *  @param deletePredicate The Predicate to mathc objects against
 */
- (void)deleteObjectsMatchingPredicate:(NSPredicate *)deletePredicate;

/**
 *  Returns a fetched results controller to monitor favorite tweets
 *
 *  @return A fetched results controller, without the delgate set
 */
- (NSFetchedResultsController *)favoritesFetchedResultsController;

/**
 *  Persist the contents of the managed object context to disk.
 */
- (void)save;

/**
 *  Returns the singleton instance of the STSCoreDataManager
 *
 *  @return The singleton instance of the STSCoreDataManager
 */
+ (instancetype)sharedInstance;

@end
