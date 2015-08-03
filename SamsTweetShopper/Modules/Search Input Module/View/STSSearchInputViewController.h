//
//  STSSearchInputViewController.h
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 02/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import <UIKit/UIKit.h>

// Protcols
#import "STSSearchInputViewInterface.h"
#import "STSSearchInputPresenterInterface.h"

@interface STSSearchInputViewController : UIViewController<STSSearchInputViewInterface>

@property (nonatomic, weak) id<STSSearchInputPresenterInterface> eventHandler;

@end
