//
//  STSTwitterAccessInteractor.h
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 02/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STSTwitterAccessInteractorInterface.h"
#import "STSSearchInputPresenterInterface.h"

@interface STSTwitterAccessInteractor : NSObject <STSTwitterAccessInteractorInterface>

@property (nonatomic, weak) id<STSSearchInputPresenterInterface> presenter;

@end
