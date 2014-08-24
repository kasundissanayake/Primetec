//
//  SuggestiveTextField.h
//  PRIMECMAPP
//
//  Created by 3SG Corporation on 8/24/14.
//
//
#import <UIKit/UIKit.h>

@interface SuggestiveTextField
: UITextField <UITextFieldDelegate, UITableViewDataSource,
UITableViewDelegate>

// Set suggestions list of NSString's.
- (void)setSuggestions:(NSArray *)suggestionStrings;

// Set Custom popover size.
- (void)setPopoverSize:(CGSize)size;

// Filter array and reload TableView
- (void)matchStrings:(NSString *)letters;

// Present PopOver
- (void)showPopOverList;

// Define if popover should hide after user selects a suggestion.
@property BOOL shouldHideOnSelection;

@end
