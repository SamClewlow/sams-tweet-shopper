//
//  STSSearchInputViewInterface.h
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 02/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  The internal interface for the view controller + view domain of the Search Input module
 */
@protocol STSSearchInputViewInterface <NSObject>

/**
 *  Tell the view if it should display a message informing the user
 *  that they have not yet allowed the app to access thier Twitter
 *  account
 *
 *  @param show Pass YES to show the message, NO to hide it.
 */
- (void)showConnectToTwitterMessage:(BOOL)showMessage
                         showButton:(BOOL)showButton;

/**
 *  Set the message the user will be shown when Twitter is not available
 *
 *  @param connectMessage The message to display
 */
- (void)setConnectToTwitterMessage:(NSString *)connectMessage;

/**
 *  Tells the view whether or not the search button should be enabled
 *  for user interaction
 *
 *  @param enable Pass YES to enable the search button.
 */
- (void)enableSearchButton:(BOOL)enable;

/**
 *  Get the currently entered search term
 *
 *  @return The currently entered search term.
 */
- (NSString *)getSearchTerm;

/**
 *  Clear the current search term
 */
- (void)clearSearchTerm;

@end
