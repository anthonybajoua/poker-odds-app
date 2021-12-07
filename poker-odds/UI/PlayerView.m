//
//  self.m
//  poker-odds
//
//  Created by Anthony on 12/6/21.
//  Copyright © 2021 Anthony Bajoua. All rights reserved.
//

#import "PlayerView.h"
#import "CardButton.h"
#import "Table.h"

@interface PlayerView()
@property Table *table;
@end

@implementation PlayerView

- (instancetype) initWithId:(NSInteger) num andTable:(Table *) table {
    if (self = [super init]) {
        UITextField* playerId = [[UITextField alloc] init];
        UITextField* winPercentage = [[UITextField alloc] init];
        UITextField* tiePercentage = [[UITextField alloc] init];
        UITextField* equity = [[UITextField alloc] init];
        UIButton *resetButton = [[UIButton alloc] init];
        UIButton *fold = [[UIButton alloc] init];
        CardButton *button1 = [[CardButton alloc] init];
        CardButton *button2 = [[CardButton alloc] init];
        button2.currentPlayer = num;
        button1.currentPlayer = num;
        button1.isPlayerCard = button2.isPlayerCard = YES;
        
        
        [self addSubview:resetButton];
        [self addSubview:fold];
        [self addSubview:button1];
        [self addSubview:button2];
        [self addSubview:playerId];
        [self addSubview:winPercentage];
        [self addSubview:tiePercentage];
        [self addSubview:equity];

        
        [button1 setAction];
        [button2 setAction];
        
        
        [self.heightAnchor constraintEqualToConstant:cardHeight + 20].active = YES;
        
        [self.widthAnchor constraintEqualToConstant:[[UIScreen mainScreen] bounds].size.width].active = YES;
        
        
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self setNeedsDisplay];
        
        
        
        [resetButton setImage:[UIImage systemImageNamed:@"clear"] forState:UIControlStateNormal];
        // TODO add reset command
        [resetButton addTarget:self action:@selector(resetCardsForPlayer) forControlEvents:UIControlEventTouchUpInside];
        resetButton.translatesAutoresizingMaskIntoConstraints = NO;
        
        
        [fold setImage:[UIImage systemImageNamed:@"f.square"] forState:UIControlStateNormal];
        [fold addTarget:self action:@selector(foldForPlayer) forControlEvents:UIControlEventTouchUpInside];
        fold.translatesAutoresizingMaskIntoConstraints = NO;
        

        playerId.translatesAutoresizingMaskIntoConstraints = NO;
        winPercentage.translatesAutoresizingMaskIntoConstraints = NO;
        tiePercentage.translatesAutoresizingMaskIntoConstraints = NO;
        equity.translatesAutoresizingMaskIntoConstraints = NO;
        
        playerId.font = winPercentage.font = tiePercentage.font = equity.font = [UIFont fontWithName:@"Courier" size:12];
        
        
        [playerId setText:[NSNumber numberWithLong:num].description];
        [winPercentage setText:@"Win %:"];
        [tiePercentage setText:@"Tie %:"];
        [equity setText:@"Equity %:"];


        [resetButton.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:40].active = YES;
        [resetButton.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:-15].active = YES;
        
        
        [fold.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:40].active = YES;
        [fold.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:15].active = YES;

        
        [playerId.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
        [playerId.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:15].active = YES;
        
        
        [winPercentage.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:-15].active = YES;
        [winPercentage.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-35].active = YES;
        
        
        [tiePercentage.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
        [tiePercentage.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-35].active = YES;
        
        
        [equity.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:15].active = YES;
        [equity.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-35].active = YES;
        
        
        [button1.trailingAnchor constraintEqualToAnchor:self.centerXAnchor constant:-8].active = YES;
        [button1.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;

        
        [button2.centerYAnchor constraintEqualToAnchor:button1.centerYAnchor].active = YES;
        [button2.leadingAnchor constraintEqualToAnchor:button1.trailingAnchor constant:16].active = YES;
    }
    return self;
}

-(void) removePlayer {
    [self removeFromSuperview];
    [self.table removePlayer];
}

- (void) foldForPlayer {
    [self grayOutCardBackgrounds];
}

- (void) resetCardsForPlayer{
    // TODO implement me
}

- (void) grayOutCardBackgrounds {
    for (UIView* insideView in self.subviews) {
        if ([insideView isKindOfClass:[CardButton class]]) {
            CardButton *btn = (CardButton*) insideView;
            if (btn.currentCard) {
                [btn setBackgroundColor:[UIColor lightGrayColor]];
            }
        }
    }
}

@end
