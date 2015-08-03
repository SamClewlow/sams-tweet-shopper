//
//  STSSearchResultsModuleInterface.h
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 02/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIViewController;
@class UINavigationController;

@protocol STSSearchResultsModuleInterface <NSObject>

/**
 *  An interface for other modules to dictate to the search module 
 *  how and where it should present
 *
 *  @param searchTerm           The search term for the module to use
 *  @param navigationController The navigation controller that the module will
 *                              present it's interface in
 */
- (void)presentResultsForSearchTerm:(NSString *)searchTerm
             inNavigationController:(UINavigationController *)navigationController;

@end
