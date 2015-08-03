//
//  STSFavoritesPresenter.h
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 02/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import <Foundation/Foundation.h>

// Protocols
#import "STSFavoritesPresenterInterface.h"
#import "STSFavoritesViewInterace.h"
#import "STSFavoritesDataInteractorInterface.h"

@interface STSFavoritesPresenter : NSObject<STSFavoritesPresenterInterface>

@property (nonatomic, strong) id<STSFavoritesViewInterace> userInterface;
@property (nonatomic, strong) id<STSFavoritesDataInteractorInterface> dataInteractor;

@end
