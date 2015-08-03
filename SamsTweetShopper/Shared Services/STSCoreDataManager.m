//
//  STSCoreDataManager.m
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 03/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import "STSCoreDataManager.h"
@import CoreData;

// Model
#import "STSManagedFavouriteTweet.h"

// Local Constants
NSString * const kFavoriteTweetEntityName = @"FavoriteTweet";
NSString * const kCreatedAtAttributeKey = @"createdAt";

#pragma mark - Interface

@interface STSCoreDataManager ()

@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end


#pragma mark - Implementation

@implementation STSCoreDataManager

#pragma mark - Singleton

+ (instancetype)sharedInstance
{
    static id sharedInstance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    
    return sharedInstance;
}


#pragma mark - Init

- (id)init
{
    if ((self = [super init]))
    {
        _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        
        NSError *error = nil;
        NSURL *applicationDocumentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                                       inDomains:NSUserDomainMask] lastObject];
    
        NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES,
                                  NSMigratePersistentStoresAutomaticallyOption: @YES,
                                  NSInferMappingModelAutomaticallyOption : @YES};
        
        NSURL *storeURL = [applicationDocumentsDirectory URLByAppendingPathComponent:@"STS-Favorites.sqlite"];
        
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil
                                                            URL:storeURL
                                                        options:options error:&error];
        
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
        _managedObjectContext.undoManager = nil;
        
    }
    
    return self;
}


#pragma mark - Public API

- (void)fetchEntriesWithPredicate:(NSPredicate *)predicate
                  sortDescriptors:(NSArray *)sortDescriptors
                       completion:(void (^)(NSArray *results))completion
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kFavoriteTweetEntityName];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    [self.managedObjectContext performBlockAndWait:^{
        
        NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
        
        if (completion)
        {
            completion(results);
        }
    }];
}

- (STSManagedFavouriteTweet *)newFavoriteTweet
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kFavoriteTweetEntityName
                                                         inManagedObjectContext:self.managedObjectContext];
    
    STSManagedFavouriteTweet *newEntry = (STSManagedFavouriteTweet *)[[NSManagedObject alloc] initWithEntity:entityDescription
                                                                              insertIntoManagedObjectContext:self.managedObjectContext];
    
    return newEntry;
}

- (void)deleteObject:(STSManagedFavouriteTweet *)tweetObject {
    
    [self.managedObjectContext performBlockAndWait:^{

        [self.managedObjectContext deleteObject:tweetObject];
        
    }];
    
    [self.managedObjectContext save:NULL];
    
}

- (void)deleteObjectsMatchingPredicate:(NSPredicate *)deletePredicate {
    
    if (deletePredicate != nil) {
        
        [[STSCoreDataManager sharedInstance] fetchEntriesWithPredicate:deletePredicate
                                                       sortDescriptors:nil
                                                            completion:^(NSArray *results) {
                                                                
                                                                if (results.count > 0) {
                                                                    
                                                                    NSLog(@"DELETEING %@", results);
                                                                    
                                                                    [self.managedObjectContext performBlockAndWait:^{
                                                                    
                                                                        // There should only be one,
                                                                        // but we will loop and delete to be defensive
                                                                        for (STSManagedFavouriteTweet *favTweet in results) {
                                                                            [self.managedObjectContext deleteObject:favTweet];
                                                                        }
                                                                    }];
                                                                    
                                                                    [self.managedObjectContext save:NULL];
                                                                }
                                                            }];
    }
    
}

- (NSFetchedResultsController *)favoritesFetchedResultsController
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:kFavoriteTweetEntityName
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:kCreatedAtAttributeKey
                                                         ascending:NO];
    
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setFetchBatchSize:0];
    
    NSFetchedResultsController *tweetFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                    managedObjectContext:self.managedObjectContext
                                                                                                      sectionNameKeyPath:nil
                                                                                                               cacheName:nil];
    
    
    return tweetFetchedResultsController;
}

- (void)save
{
    [self.managedObjectContext save:NULL];
}

@end
