//
//  STSSearchInputModuleInterface.h
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 02/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;


@protocol STSSearchInputModuleInterface <NSObject>

/**
 *  Get the root navigation controller for the module
 *
 *  @return The root navigation controller
 */
- (UINavigationController *)getUserInterface;

/**
 *  A hook for the presenter to let the wireframe know it's
 *  time to hand off to the next module
 *
 *  @param searchTerm The search term
 */
- (void)readyToPerformSearchWithSearchTerm:(NSString *)searchTerm;

/**
 *  Let the wireframe know the view has been presented, so it can
 *  tear down any other modules it may be hanging on to.
 */
- (void)viewWasPresented;

@end
