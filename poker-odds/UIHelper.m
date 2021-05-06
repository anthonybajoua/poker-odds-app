//
//  UIHelper.m
//  poker-odds
//
//  Created by Anthony Bajoua on 5/5/21.
//  Copyright © 2021 Anthony Bajoua. All rights reserved.
//

#import "UIHelper.h"

@implementation UIHelper

const int kNumPlayersDefault = 3;
const int kNumPlayersMax = 10;
const int kNumPlayersMin = 2;
const int cardHeight = 88;
const int cardWidth = 56;

UIImage *backImg;

int numPlayers = 0;

- (instancetype) init {
    if (self = [super init]) {
        backImg = [UIImage imageNamed:@"back"];
    }
    return self;
}



#pragma mark player scroll view creation

- (UIScrollView *) createPlayerScrollViewWithStackView:(UIStackView *) playerStackView
                                              andWidth:(NSInteger)width
{
    UIScrollView *playerScrollView = [[UIScrollView alloc] init];
    playerScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    playerScrollView.userInteractionEnabled = YES;
    [playerScrollView setNeedsDisplay];
    
    
    [playerStackView.topAnchor constraintEqualToAnchor:playerScrollView.topAnchor].active = YES;
    [playerStackView.bottomAnchor constraintEqualToAnchor:playerScrollView.bottomAnchor].active = YES;
    [playerStackView.leadingAnchor constraintEqualToAnchor:playerScrollView.leadingAnchor].active = YES;
    [playerStackView.trailingAnchor constraintEqualToAnchor:playerScrollView.trailingAnchor].active = YES;
    
    
    return playerScrollView;
}

#pragma mark player stack view creation

- (UIStackView *) createPlayerStackView:(NSInteger) numPlayers {
    UIStackView *playerStackView = [[UIStackView alloc] init];
    playerStackView.translatesAutoresizingMaskIntoConstraints = NO;
    playerStackView.axis = UILayoutConstraintAxisVertical;
    playerStackView.distribution = UIStackViewDistributionEqualSpacing;
    playerStackView.alignment = UIStackViewAlignmentCenter;
    playerStackView.spacing = 10;
    
    
    [playerStackView setNeedsDisplay];

    for (int i = 0; i < numPlayers; i++) {
        [playerStackView addArrangedSubview:[self createPlayerView]];
    }
    return playerStackView;
}

#pragma mark player view creation
- (UIView *) createPlayerView {
    UIView *playerView = [[UIView alloc] init];
    [playerView.heightAnchor constraintEqualToConstant:cardHeight + 20].active = YES;
    [playerView.widthAnchor constraintEqualToConstant:self.view.frame.size.width].active = YES;
    
    playerView.translatesAutoresizingMaskIntoConstraints = NO;
    [playerView setNeedsDisplay];
    
    
    UIButton *resetButton = [[UIButton alloc] init];
    [resetButton setImage:[UIImage systemImageNamed:@"clear"] forState:UIControlStateNormal];
    [resetButton addTarget:self action:@selector(resetCardsForPlayer:) forControlEvents:UIControlEventTouchUpInside];
    resetButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIButton *fold = [[UIButton alloc] init];
    [fold setImage:[UIImage systemImageNamed:@"f.square"] forState:UIControlStateNormal];
    [fold addTarget:self action:@selector(foldForPlayer:) forControlEvents:UIControlEventTouchUpInside];
    fold.translatesAutoresizingMaskIntoConstraints = NO;
    
    CardButton *button1 = [[CardButton alloc] init];
    CardButton *button2 = [[CardButton alloc] init];
    
    
    UITextField* playerId = [[UITextField alloc] init];
    UITextField* winPercentage = [[UITextField alloc] init];
    UITextField* tiePercentage = [[UITextField alloc] init];
    UITextField* equity = [[UITextField alloc] init];

    playerId.translatesAutoresizingMaskIntoConstraints = NO;
    winPercentage.translatesAutoresizingMaskIntoConstraints = NO;
    tiePercentage.translatesAutoresizingMaskIntoConstraints = NO;
    equity.translatesAutoresizingMaskIntoConstraints = NO;
    
    playerId.font = winPercentage.font = tiePercentage.font = equity.font = [UIFont fontWithName:@"Courier" size:12];
    
    
    
    [playerId setText:[NSNumber numberWithInt:++numPlayers].description];
    [winPercentage setText:@"Win %:"];
    [tiePercentage setText:@"Tie %:"];
    [equity setText:@"Equity %:"];

    [playerView addSubview:resetButton];
    [playerView addSubview:fold];
    [playerView addSubview:button1];
    [playerView addSubview:button2];
    [playerView addSubview:playerId];
    [playerView addSubview:winPercentage];
    [playerView addSubview:tiePercentage];
    [playerView addSubview:equity];

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
    
    return playerView;
}



#pragma mark Reset action

- (IBAction)resetCardsForPlayer:(UIButton *)sender {
    [self deleteCardsFromView:[sender superview]];
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
                [btn setBackgroundImage:backImg forState:UIControlStateNormal];
                [btn setBackgroundColor:[UIColor whiteColor]];
            }
        }
    }
}



#pragma mark Fold action

- (IBAction)foldForPlayer:(UIButton *)sender {
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

@end
