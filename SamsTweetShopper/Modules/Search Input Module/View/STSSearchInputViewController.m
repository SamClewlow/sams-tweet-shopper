//
//  STSSearchInputViewController.m
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 02/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import "STSSearchInputViewController.h"


#pragma mark - Internal Constants

static CGFloat const kDisabledAlphaValue = 0.4;
static CGFloat const kEnabledAlphaValue = 1.0;

#pragma mark - Interface

@interface STSSearchInputViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchTermTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIView *enableTwitterContainerView;
@property (weak, nonatomic) IBOutlet UILabel *enableTwitterLabel;
@property (weak, nonatomic) IBOutlet UIButton *enableTwitterButton;

@end


#pragma mark - Implementation

@implementation STSSearchInputViewController


#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];


    // Set up a tap gesture
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(resignFirstResponder:)];
    
    [self.view addGestureRecognizer:tapGesture];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.eventHandler viewWasDisplayed];
}


#pragma mark - STSSearchInputViewInterface

- (void)showConnectToTwitterMessage:(BOOL)showMessage
                         showButton:(BOOL)showButton {
    
    self.enableTwitterContainerView.hidden = !showMessage;
    [self enableSearchViews:!showMessage];
    self.enableTwitterButton.hidden = !showButton;
}

- (void)enableSearchButton:(BOOL)enable {

    self.searchButton.enabled = enable;
}

- (void)setConnectToTwitterMessage:(NSString *)connectMessage {
    
    self.enableTwitterLabel.text = connectMessage;
}

- (void)clearSearchTerm {
    
    self.searchTermTextField.text = @"";
}

- (NSString *)getSearchTerm {
    
    return self.searchTermTextField.text;
}


#pragma mark - View Manipulation

- (void)enableSearchViews:(BOOL)enable {
    
    if (enable) {
        
        // Enable the text field
        self.searchTermTextField.userInteractionEnabled = YES;
        self.searchTermTextField.alpha = kEnabledAlphaValue;
        
        // Enable the button
        self.searchButton.alpha = kEnabledAlphaValue;
        
    } else {
        
        // Disable the text field
        self.searchTermTextField.userInteractionEnabled = NO;
        self.searchTermTextField.alpha = kDisabledAlphaValue;
        
        // Disable the button
        self.searchButton.alpha = kDisabledAlphaValue;

        self.searchButton.enabled = NO;
        
        [self.searchTermTextField resignFirstResponder];
    }
}


#pragma mark - Actions

- (IBAction)searchButtonTapped:(id)sender {
    
    //  Pass event through to the event handler
    [self.eventHandler searchButtonTapped];
    [self.searchTermTextField resignFirstResponder];
}

- (IBAction)enableTwitterTapped:(id)sender {

    //  Pass event through to the event handler
    [self.eventHandler enableTwitterTapped];
}

- (void)resignFirstResponder:(id)sender {
    
    [self.searchTermTextField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    
    // Let the event handler know the user changed the search term
    
    NSString *stringAfterEdit = [textField.text stringByReplacingCharactersInRange:range
                                                                        withString:string];
    
    [self.eventHandler searchTermDidChange:stringAfterEdit];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    // Allow the user to initiate a search from the keyboard
    // if the go button is enabled.
    if (self.searchButton.enabled) {
        
        [self searchButtonTapped:nil];
        return YES;
        
    } else {
        
        return NO;
    }
}


@end
