//
//  STSSearchFavoritesInteractorInterface.h
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 02/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import <Foundation/Foundation.h>

@class STSSearchResultTweet;

@protocol STSSearchFavoritesInteractorInterface <NSObject>

/**
 *  Adds the passed in tweet to the users favorites, and persisits it.
 *
 *  @param searchResultTweet The tweet to add.
 */
- (void)addSearchResultTweetToFavorites:(STSSearchResultTweet *)searchResultTweet;

/**
 *  Removes the passed in tweet from the users favorites, if it exists.
 *
 *  @param searchResultTweet The tweet to remove.
 */
- (void)removeSearchResultTweetFromFavorites:(STSSearchResultTweet *)searchResultTweet;

/**
 *  Tells whether or not a tweet is saved as a favorite, matching by tweet ID
 *
 *  @param searchResultTweet The tweet to test
 *
 *  @return YES if the tweet is stored as a favorite.
 */
- (BOOL)isSearchResultTweetAFavorite:(STSSearchResultTweet *)searchResultTweet;

@end
