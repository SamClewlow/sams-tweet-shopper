//
//  STSFavoritesViewController.h
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 02/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import <UIKit/UIKit.h>

// Protocols
#import "STSFavoritesViewInterace.h"
#import "STSFavoritesPresenterInterface.h"


@interface STSFavoritesViewController : UIViewController<STSFavoritesViewInterace>

@property (nonatomic, weak) id<STSFavoritesPresenterInterface> eventHandler;

@end
