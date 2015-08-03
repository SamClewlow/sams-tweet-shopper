//
//  STSFavoritesModuleInterface.h
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 02/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;


@protocol STSFavoritesModuleInterface <NSObject>

/**
 *  Returns the user interface, for routing purposes
 *
 *  @return A UINavigationController with the root View Controller installed
 */
- (UINavigationController *)getUserInterface;

@end
