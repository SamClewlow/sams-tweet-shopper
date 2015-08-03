//
//  STSFavoritesViewInterace.h
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 02/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  The internal interface for the view controller + view domain of the Favorites module
 */
@protocol STSFavoritesViewInterace <NSObject>

/**
 *  Tell the view to present the tweet view models
 *
 *  @param favorites The view models to present
 */
- (void)presentFavoriteTweets:(NSArray *)favorites;

/**
 *  Tell the view there has been an update, indicating which indexes have been removed
 *
 *  @param favorites The updated view models
 *  @param indexSet  The indexs that have been deleted
 */
- (void)updateFavoriteTweets:(NSArray *)favorites
            deleteIndexs:(NSIndexSet *)indexSet;

@end
