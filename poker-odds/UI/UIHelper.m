//
//  UIHelper.m
//  poker-odds
//
//  Created by Anthony Bajoua on 5/5/21.
//  Copyright © 2021 Anthony Bajoua. All rights reserved.
//

#import "UIHelper.h"

@implementation UIHelper {
    long numPlayers;
};

UIImage * backImg;
NSDictionary *nameDictionary;

int screenWidth;
NSMutableArray *playerViews;
NSMutableArray *equities;
NSMutableArray *ties;
NSMutableArray *wins;
NSMutableSet *cardsOnTable;
Table *table;


- (instancetype) init {
    if (self = [super init]) {
        playerViews = [NSMutableArray array];
        equities = [NSMutableArray array];
        ties = [NSMutableArray array];
        wins = [NSMutableArray array];
        table = [[Table alloc] init];
        cardsOnTable = [NSMutableSet set];
        
        
        
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
    
    
    for (int i = 0; i < wins.count; i++) {
        
        NSString *winPercent = [[winResults objectAtIndex:i] description];
        NSString *tiePercent = [[tieResults objectAtIndex:i] description];

        ((UITextField *) [wins objectAtIndex:i]).text = [NSString stringWithFormat:@"Win %% %@", winPercent];
        ((UITextField *) [ties objectAtIndex:i]).text = [NSString stringWithFormat:@"Tie %% %@", tiePercent];
    }
}

#pragma mark player scroll view creation

- (void) completePlayerScrollView:(UIScrollView *) playerScrollView
{
    
    screenWidth = [playerScrollView superview].frame.size.width;
    
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
        UIView *playerView = [self createPlayerView];
        [playerStackView addArrangedSubview:playerView];
    }
    return playerStackView;
}

#pragma mark player view creation

- (UIView *) createPlayerView {
    UIView *playerView = [[UIView alloc] init];
    UITextField* playerId = [[UITextField alloc] init];
    UITextField* winPercentage = [[UITextField alloc] init];
    UITextField* tiePercentage = [[UITextField alloc] init];
    UITextField* equity = [[UITextField alloc] init];
    UIButton *resetButton = [[UIButton alloc] init];
    UIButton *fold = [[UIButton alloc] init];
    CardButton *button1 = [[CardButton alloc] init];
    CardButton *button2 = [[CardButton alloc] init];
    button2.currentPlayer = numPlayers;
    button1.currentPlayer = numPlayers;
    button1.isPlayerCard = button2.isPlayerCard = YES;
    
    [wins addObject:winPercentage];
    [ties addObject:tiePercentage];
    [equities addObject:equity];
    
    [playerView addSubview:resetButton];
    [playerView addSubview:fold];
    [playerView addSubview:button1];
    [playerView addSubview:button2];
    [playerView addSubview:playerId];
    [playerView addSubview:winPercentage];
    [playerView addSubview:tiePercentage];
    [playerView addSubview:equity];

    
    [button1 setAction];
    [button2 setAction];
    
    
    [playerView.heightAnchor constraintEqualToConstant:cardHeight + 20].active = YES;
    [playerView.widthAnchor constraintEqualToConstant:screenWidth].active = YES;
    
    
    playerView.translatesAutoresizingMaskIntoConstraints = NO;
    [playerView setNeedsDisplay];
    
    
    
    [resetButton setImage:[UIImage systemImageNamed:@"clear"] forState:UIControlStateNormal];
    [resetButton addTarget:self action:@selector(resetCardsForPlayer:) forControlEvents:UIControlEventTouchUpInside];
    resetButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    [fold setImage:[UIImage systemImageNamed:@"f.square"] forState:UIControlStateNormal];
    [fold addTarget:self action:@selector(foldForPlayer:) forControlEvents:UIControlEventTouchUpInside];
    fold.translatesAutoresizingMaskIntoConstraints = NO;
    

    playerId.translatesAutoresizingMaskIntoConstraints = NO;
    winPercentage.translatesAutoresizingMaskIntoConstraints = NO;
    tiePercentage.translatesAutoresizingMaskIntoConstraints = NO;
    equity.translatesAutoresizingMaskIntoConstraints = NO;
    
    playerId.font = winPercentage.font = tiePercentage.font = equity.font = [UIFont fontWithName:@"Courier" size:12];
    
    
    [playerId setText:[NSNumber numberWithLong:numPlayers].description];
    [winPercentage setText:@"Win %:"];
    [tiePercentage setText:@"Tie %:"];
    [equity setText:@"Equity %:"];


    [resetButton.leadingAnchor constraintEqualToAnchor:playerView.leadingAnchor constant:40].active = YES;
    [resetButton.centerYAnchor constraintEqualToAnchor:playerView.centerYAnchor constant:-15].active = YES;
    
    
    [fold.leadingAnchor constraintEqualToAnchor:playerView.leadingAnchor constant:40].active = YES;
    [fold.centerYAnchor constraintEqualToAnchor:playerView.centerYAnchor constant:15].active = YES;

    
    [playerId.centerYAnchor constraintEqualToAnchor:playerView.centerYAnchor].active = YES;
    [playerId.leadingAnchor constraintEqualToAnchor:playerView.leadingAnchor constant:15].active = YES;
    
    
    [winPercentage.centerYAnchor constraintEqualToAnchor:playerView.centerYAnchor constant:-15].active = YES;
    [winPercentage.trailingAnchor constraintEqualToAnchor:playerView.trailingAnchor constant:-35].active = YES;
    
    
    [tiePercentage.centerYAnchor constraintEqualToAnchor:playerView.centerYAnchor].active = YES;
    [tiePercentage.trailingAnchor constraintEqualToAnchor:playerView.trailingAnchor constant:-35].active = YES;
    
    
    [equity.centerYAnchor constraintEqualToAnchor:playerView.centerYAnchor constant:15].active = YES;
    [equity.trailingAnchor constraintEqualToAnchor:playerView.trailingAnchor constant:-35].active = YES;
    
    
    [button1.trailingAnchor constraintEqualToAnchor:playerView.centerXAnchor constant:-8].active = YES;
    [button1.centerYAnchor constraintEqualToAnchor:playerView.centerYAnchor].active = YES;

    
    [button2.centerYAnchor constraintEqualToAnchor:button1.centerYAnchor].active = YES;
    [button2.leadingAnchor constraintEqualToAnchor:button1.trailingAnchor constant:16].active = YES;
    
    [playerViews addObject:playerView];
    
    numPlayers++;
    return playerView;
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
                [cardsOnTable removeObject:btn.currentCard];
                
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
        UIView *playerView = [self createPlayerView];
        [_playerStackView addArrangedSubview:playerView];
        [table addPlayer];
    }
}

-(void) removePlayer {
    if (numPlayers > kNumPlayersMin) {
        
        [wins removeLastObject];
        [equities removeLastObject];
        [ties removeLastObject];
        
        UIView *viewToRemove = [playerViews objectAtIndex:playerViews.count - 1];
        [self deleteCardsFromView:viewToRemove];
        [viewToRemove removeFromSuperview];
        [playerViews removeLastObject];
        numPlayers--;
        
        [table removePlayer];
    }
}

- (void)foldForPlayer:(UIButton *)sender {
    [self grayOutCardBackgrounds:[sender superview]];
}

- (void)grayOutCardBackgrounds:(UIView*)view {
    for (UIView* insideView in view.subviews) {
        if (insideView.subviews.count > 0) {
            [self grayOutCardBackgrounds:insideView];
        }
        if ([insideView isKindOfClass:[CardButton class]]) {
            CardButton *btn = (CardButton*) insideView;
            if (btn.currentCard) {
                [btn setBackgroundColor:[UIColor lightGrayColor]];
            }
        }
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
                    
                    if (![cardsOnTable containsObject:card]) {
                        [cardsOnTable addObject:card];
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
        [cardsOnTable removeObject:btn.currentCard];

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
