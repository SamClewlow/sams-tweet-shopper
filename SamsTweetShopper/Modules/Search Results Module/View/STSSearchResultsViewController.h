//
//  STSSearchResultsViewController.h
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 02/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import <UIKit/UIKit.h>

// Protocols
#import "STSSearchResultsViewInterface.h"
#import "STSSearchResultsPresenterInterface.h"

@interface STSSearchResultsViewController : UIViewController<STSSearchResultsViewInterface>

@property (nonatomic, weak) id<STSSearchResultsPresenterInterface> eventHandler;

@end
