//
//  UIHelper.m
//  poker-odds
//
//  Created by Anthony Bajoua on 5/5/21.
//  Copyright © 2021 Anthony Bajoua. All rights reserved.
//

#import "UIHelper.h"
#import "PlayerView.h"

@implementation UIHelper {
    long numPlayers;
};

UIImage * backImg;
NSDictionary *nameDictionary;
Table *table;

- (instancetype) init {
    if (self = [super init]) {
        backImg = [UIImage imageNamed:@"back"];
        
        nameDictionary = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:
                                                                @"ace", @"ace", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"10", @"jack", @"queen", @"king", @"spades", @"clubs", @"diamonds", @"hearts", nil]
                                                       forKeys:[NSArray arrayWithObjects:
                                                                @"a", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"t", @"j", @"q", @"k", @"s", @"c", @"d", @"h", nil]];
        
    }
    return self;
}

- (void) simulate {
    
    NSArray *results = [table simulate];
    
    NSArray *tieResults = [results objectAtIndex:0];
    NSArray *winResults = [results objectAtIndex:1];
    

    NSLog(@"%@", winResults);
    NSLog(@"%@", tieResults);
    
    
    for (int i = 0; i < table.wins.count; i++) {
        
        NSString *winPercent = [[winResults objectAtIndex:i] description];
        NSString *tiePercent = [[tieResults objectAtIndex:i] description];

        PlayerView *playerView = [[_playerStackView arrangedSubviews] objectAtIndex:i];
        playerView.winPercent.text = [NSString stringWithFormat:@"Win %% %@", winPercent];
        playerView.tiePercent.text = [NSString stringWithFormat:@"Tie %% %@", tiePercent];
    }
}

#pragma mark player scroll view creation

- (void) completePlayerScrollView:(UIScrollView *) playerScrollView
{
    
    playerScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    playerScrollView.userInteractionEnabled = YES;
    [playerScrollView setNeedsDisplay];
    
    _playerScrollView = playerScrollView;
    _playerStackView = [self createPlayerStackView];
    
    [playerScrollView addSubview:_playerStackView];
    
    [_playerStackView.topAnchor constraintEqualToAnchor:playerScrollView.topAnchor].active = YES;
    [_playerStackView.bottomAnchor constraintEqualToAnchor:playerScrollView.bottomAnchor].active = YES;
    [_playerStackView.leadingAnchor constraintEqualToAnchor:playerScrollView.leadingAnchor].active = YES;
    [_playerStackView.trailingAnchor constraintEqualToAnchor:playerScrollView.trailingAnchor].active = YES;
    
}

#pragma mark player stack view creation

- (UIStackView *) createPlayerStackView{
    UIStackView *playerStackView = [[UIStackView alloc] init];
    playerStackView.translatesAutoresizingMaskIntoConstraints = NO;
    playerStackView.axis = UILayoutConstraintAxisVertical;
    playerStackView.distribution = UIStackViewDistributionEqualSpacing;
    playerStackView.alignment = UIStackViewAlignmentCenter;
    playerStackView.spacing = 10;
    
    
    [playerStackView setNeedsDisplay];

    for (int i = 0; i < kNumPlayersDefault; i++) {
        PlayerView *playerView = [[PlayerView alloc] initWithId:i andTable:table];
        [playerStackView addArrangedSubview:playerView];
    }
    numPlayers = kNumPlayersDefault;
    return playerStackView;
}

#pragma mark Reset action

- (void)resetCardsForPlayer:(UIButton *)sender {
    [self deleteCardsFromView:[sender superview]];
    [table reset];
}

- (void)deleteCardsFromView:(UIView*)view {
    for (UIView* insideView in view.subviews) {
        if (insideView.subviews.count > 0) {
            [self deleteCardsFromView:insideView];
        }
        if ([insideView isKindOfClass:[CardButton class]]) {
            CardButton *btn = (CardButton*) insideView;
            if (btn.currentCard) {
                [table.cardsOnTable removeObject:btn.currentCard];
                
                if (btn.isPlayerCard) {
                    [table removeCard:btn.currentCard fromHand:btn.currentPlayer];
                } else {
                    [table removeCardFromTable:btn.currentCard];
                }
                
                [btn setBackgroundImage:backImg forState:UIControlStateNormal];
                [btn setBackgroundColor:[UIColor whiteColor]];
            }
        }
    }
}



#pragma mark - Buttons

-(void) addPlayer {
    if (numPlayers < kNumPlayersMax) {
        PlayerView *playerView = [[PlayerView alloc] initWithId:numPlayers++ andTable:table];
        [_playerStackView addArrangedSubview:playerView];
        [table addPlayer];
    }
}

- (void) removePlayer{
    NSArray *playerViews = [_playerStackView arrangedSubviews];
    if (playerViews.count - 1 >= kNumPlayersMin) {
        [[playerViews objectAtIndex:playerViews.count - 1] removeFromSuperview];
    }
}

#pragma mark - User Input Card

-(void) getInputForButton:(id)sender
           withCompletion:(void (^)(UIAlertController*)) completion {
    CardButton *btn = (CardButton *) sender;
    if (!btn.currentCard) {
        UIAlertController *alert= [UIAlertController
                                      alertControllerWithTitle:@"Select card"
                                      message:@"Please select a card"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];

        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
            
            NSString *card, *rank, *suit;
            card = alert.textFields[0].text;
            if (card.length >= 2) {
                rank = [nameDictionary objectForKey:[[card substringToIndex:card.length - 1] lowercaseString]];
                suit = [nameDictionary objectForKey:[[card substringFromIndex:card.length - 1] lowercaseString]];
                if (rank && suit) {
                    card = [NSString stringWithFormat:@"%@_of_%@", rank, suit];
                    
                    if (![table.cardsOnTable containsObject:card]) {
                        [table.cardsOnTable addObject:card];
                        [sender setBackgroundImage:[UIImage imageNamed:card] forState:UIControlStateNormal];
                        btn.currentCard = card;
                        
                        if (btn.isPlayerCard) {
                            [table addCard:card toHand:btn.currentPlayer];
                        } else {
                            [table addCardToTable:card];
                        }
                    }
                }
                
            }
        }];

        [alert addAction:ok];
        [alert addAction:cancel];

        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Input card, e.g. ah, ac ... 5d, 5s ... jd ";
            textField.keyboardType = UIKeyboardTypeDefault;
            
        }];
        
        completion(alert);

    } else {
        [table.cardsOnTable removeObject:btn.currentCard];

        [btn setBackgroundImage:backImg forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor whiteColor]];
        
        
        if (btn.isPlayerCard) {
            [table removeCard:btn.currentCard fromHand:btn.currentPlayer];
        } else {
            [table removeCardFromTable:btn.currentCard];
        }
        btn.currentCard = nil;
    }
    
}

@end
