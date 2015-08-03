//
//  STSSearchResultsPresenterInterface.h
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 02/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol STSSearchResultsPresenterInterface <NSObject>

// For Wireframe
/**
 *  Set the search term to use
 *
 *  @param searchTerm The search term
 */
- (void)setSearchTerm:(NSString *)searchTerm;

// For View

/**
 *  Let the presenter know the view is good to go
 */
- (void)viewWasDisplayed;

/**
 *  User has indicated thay want to save a favorite
 *
 *  @param index The index of the item selected by the user
 */
- (void)userDidSelectFavoriteAtIndex:(NSInteger)index;

/**
 *  User has indicated thay want to delete a favorite
 *
 *  @param index The index of the item selected by the user
 */
- (void)userDidSelectUnFavoriteAtIndex:(NSInteger)index;

@end
