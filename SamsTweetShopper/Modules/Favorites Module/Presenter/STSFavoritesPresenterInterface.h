//
//  STSFavoritesPresenterInterface.h
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 02/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol STSFavoritesPresenterInterface <NSObject>

/**
 *  Lets the presenter know the view is ready
 */
- (void)viewWasDisplayed;

/**
 *  Notify the presenter the user wishes to remove a favorite
 *
 *  @param index The idex of the item to remove
 */
- (void)userDidSelectUnFavoriteAtIndex:(NSInteger)index;

@end
