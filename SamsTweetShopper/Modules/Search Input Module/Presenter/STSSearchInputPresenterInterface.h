//
//  STSSearchInputPresenterInterface.h
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 02/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STSTwitterAccessInteractorInterface.h"

@protocol STSSearchInputPresenterInterface <NSObject>

/**
 *  Call when the view is ready to go
 */
- (void)viewWasDisplayed;

/**
 *  Delegate the handling of the search action
 */
- (void)searchButtonTapped;

/**
 *  Delegate the handling of the enable Twitter action
 */
- (void)enableTwitterTapped;

/**
 *  The search term has changed
 *
 *  @param searchTerm The updated search term
 */
- (void)searchTermDidChange:(NSString *)searchTerm;

/**
 *  The Twitter auth status has been updated
 *
 *  @param authStatus The new status
 */
- (void)twitterAuthStatusUpdated:(STSTwitterAccessResponse)authStatus;

@end
