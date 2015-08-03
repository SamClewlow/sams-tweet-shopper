//
//  STSSearchInputPresenter.h
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 02/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import <Foundation/Foundation.h>

// Protocols
#import "STSSearchInputPresenterInterface.h"

// View
#import "STSSearchInputViewInterface.h"

// Interactors
#import "STSTwitterAccessInteractorInterface.h"
#import "STSSearchTermValidInteractorInterface.h"

// Wireframe
#import "STSSearchInputModuleInterface.h"

@interface STSSearchInputPresenter : NSObject <STSSearchInputPresenterInterface>

@property (nonatomic, strong) id<STSSearchInputViewInterface> userInterface;
@property (nonatomic, strong) id<STSTwitterAccessInteractorInterface> twitterAccessInteractor;
@property (nonatomic, strong) id<STSSearchTermValidInteractorInterface> searchTermValidationInteractor;
@property (nonatomic, weak) id<STSSearchInputModuleInterface> wireframe;

@end
