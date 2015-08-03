//
//  STSSearchResultsViewInterface.h
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 02/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  The internal interface for the view controller + view domain of the Search Results module
 */
@protocol STSSearchResultsViewInterface <NSObject>

/**
 *  Show the loading state
 *
 *  @param show YES to show, NO to hids
 */
- (void)showLoadingState:(BOOL)show;

/**
 *  Show the error message passed in
 *
 *  @param errorMessage An error message string
 */
- (void)showErrorMessage:(NSString *)errorMessage;

/**
 *  Present the view models to the user
 *
 *  @param searchResults The view models
 */
- (void)presentSearchResults:(NSArray *)searchResults;

/**
 *  Tell the view there has been an update, indicating which indexes have been changed
 *
 *  @param favorites The updated view models
 *  @param indexSet  The indexs that have been changed
 */
- (void)updateSearchResults:(NSArray *)searchResults
            reloadingIndexs:(NSIndexSet *)indexSet;

@end

