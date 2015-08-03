//
//  STSSearchResultsPresenter.h
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 02/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import <Foundation/Foundation.h>

// Protocols
#import "STSSearchResultsPresenterInterface.h"
#import "STSSearchResultsModuleInterface.h"
#import "STSSearchResultsViewInterface.h"
#import "STSTwitterSearchInteractorInterface.h"
#import "STSSearchFavoritesInteractorInterface.h"

@interface STSSearchResultsPresenter : NSObject<STSSearchResultsPresenterInterface>

@property (nonatomic, strong) id<STSSearchResultsViewInterface> userInterface;
@property (nonatomic, strong) id<STSTwitterSearchInteractorInterface> twitterSearchInteractor;
@property (nonatomic, strong) id<STSSearchFavoritesInteractorInterface> favouritesInteractor;
@property (nonatomic, weak) id<STSSearchResultsModuleInterface> wireframe;

@end
