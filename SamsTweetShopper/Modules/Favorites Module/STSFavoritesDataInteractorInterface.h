//
//  STSFavoritesDataInteractorInterface.h
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 03/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import <Foundation/Foundation.h>

@class STSManagedFavouriteTweet;

@protocol STSFavoritesDataInteractorInterface <NSObject>

/**
 *  Get the currently saved STSManagedFavouriteTweet objects
 *
 *  @return An array of the currently saved STSManagedFavouriteTweet objects
 */
- (NSArray * )getManagedFavoriteDataObjects;

/**
 *  Delete the passed in object
 *
 *  @param favoriteTweet The tweet to delete
 */
- (void)deleteFavoriteTweet:(STSManagedFavouriteTweet *)favoriteTweet;

@end
