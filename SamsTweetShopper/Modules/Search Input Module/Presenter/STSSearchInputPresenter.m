//
//  STSSearchInputPresenter.m
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 02/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import "STSSearchInputPresenter.h"

@implementation STSSearchInputPresenter


#pragma mark - STSSearchInputPresenterInterface

- (void)viewWasDisplayed {
    
    // Set the view state depending on the Twitter auth status
    [self updateViewForTwitterStatus:[self.twitterAccessInteractor twitterAccessCurrentStatus]];
    
    // Set the correct state for the search button. Need to do this intially after view
    // has been displayed as otherwise a check won't be done until an edit is made. 
    [self searchTermDidChange:[self.userInterface getSearchTerm]];
    
    [self.wireframe viewWasPresented];
}

- (void)searchButtonTapped {

    // Hand off to the next module
    [self.wireframe readyToPerformSearchWithSearchTerm:[self.userInterface getSearchTerm]];
    [self.userInterface clearSearchTerm];
}

- (void)enableTwitterTapped {
    
    __weak typeof(self) weakSelf = self;
    
    // Pass the task to the interactor and interpret the response for the view
    [self.twitterAccessInteractor requestAccessToTwitterWithCompletion:^(STSTwitterAccessResponse response) {
        
        [weakSelf updateViewForTwitterStatus:response];
    }];
    
}

- (void)searchTermDidChange:(NSString *)searchTerm {
    
    // Ask the interactor to validate the current search term
    BOOL isValid = [self.searchTermValidationInteractor isSearchTermValid:searchTerm];
    
    // Set the appropiate state on the view
    [self.userInterface enableSearchButton:isValid];
}

- (void)twitterAuthStatusUpdated:(STSTwitterAccessResponse)authStatus {
    
    [self updateViewForTwitterStatus:authStatus];
}

#pragma mark - View Manipulation

- (void)updateViewForTwitterStatus:(STSTwitterAccessResponse)status {
    
    // Translate the meaning of the Twitter Auth status for the view
    switch (status) {
            
        case STSTwitterAccessResponseGranted: {
            
            [self.userInterface showConnectToTwitterMessage:NO
                                                 showButton:NO];
            break;
        }
        case STSTwitterAccessResponseDenied: {
            
            [self.userInterface showConnectToTwitterMessage:YES
                                                 showButton:NO];
            [self.userInterface setConnectToTwitterMessage:@"Hola! We need Twitter account access, please enable it in your device Settings."];
            
            break;
        }
        case STSTwitterAccessResponseNoAccounts: {
            
            [self.userInterface showConnectToTwitterMessage:YES
                                                 showButton:NO];
            [self.userInterface setConnectToTwitterMessage:@"Hola! This app uses Twitter, please add a Twitter account in your device Settings."];
            
            break;
        }
        case STSTwitterAccessResponseNotAsked: {
            
            [self.userInterface showConnectToTwitterMessage:YES
                                                 showButton:YES];
            [self.userInterface setConnectToTwitterMessage:@"Hola! This app uses Twitter, tap the button to allow access."];
            
            break;
        }
        default:
            break;
    }
    
    [self.userInterface clearSearchTerm];
    
}

@end
