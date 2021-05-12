//
//  CardButton.m
//  poker-odds
//
//  Created by Anthony Bajoua on 5/5/21.
//  Copyright © 2021 Anthony Bajoua. All rights reserved.
//

#import "CardButton.h"

@implementation CardButton
const int cardHeight = 88;
const int cardWidth = 56;

static UIImage *backImg;
static NSDictionary *nameDictionary;


//Only have one object for the image of all the cards backs.
+ (void) initialize {
    backImg = [UIImage imageNamed:@"back"];
}

- (instancetype) init {
    self = [super init];
    if (self) {

        [self setBackgroundImage:backImg forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor whiteColor]];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self.widthAnchor constraintEqualToConstant:cardWidth].active = YES;
        [self.heightAnchor constraintEqualToConstant:cardHeight].active = YES;
    }
    return self;
}

- (void) setAction {
    [self addTarget:nil action:@selector(addCardToTable:) forControlEvents:UIControlEventTouchUpInside];
}


@end
