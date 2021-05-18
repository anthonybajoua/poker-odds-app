//
//  UIHelper.h
//  poker-odds
//
//  Created by Anthony Bajoua on 5/5/21.
//  Copyright © 2021 Anthony Bajoua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CardButton.h"
#import "Table.h"

NS_ASSUME_NONNULL_BEGIN

/** This class is concerned with creating all subviews the main view needs.*/
@interface UIHelper : NSObject
@property (atomic, strong) UIStackView *playerStackView;
@property (atomic, strong) UIScrollView *playerScrollView;

/**Creates the main view used for the UI*/
- (void) completePlayerScrollView:(UIScrollView *) scrollView;

/**Clears all the cards from the selected view also reshuffling them back into the deck.*/
- (void) deleteCardsFromView:(UIView*) view;

/** Creates the alert to be displayed to the user to select their card and calls back to the view controller in the completion to display it.*/
-(void) getInputForButton:(id)sender
           withCompletion:(void (^)(UIAlertController*)) completion;


/**Adds a player if below the limit of 10*/
-(void) addPlayer;

/**Removes a player if above the limit of 2*/
-(void) removePlayer;

@end

NS_ASSUME_NONNULL_END
