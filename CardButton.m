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
UIImage *backImg;
NSDictionary *nameDictionary;


//Only have one object for the image of all the cards backs.
+ (void) initialize {
    backImg = [UIImage imageNamed:@"back"];
    nameDictionary = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:
                                                            @"ace", @"ace", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"10", @"jack", @"queen", @"king", @"spades", @"clubs", @"diamonds", @"hearts", nil]
                                                   forKeys:[NSArray arrayWithObjects:
                                                            @"a", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"t", @"j", @"q", @"k", @"s", @"c", @"d", @"h", nil]];
}

- (instancetype) initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {

        [self setBackgroundImage:backImg forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self addTarget:self action:@selector(getInputForButton:) forControlEvents:UIControlEventTouchUpInside];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self.widthAnchor constraintEqualToConstant:cardWidth].active = YES;
        [self.heightAnchor constraintEqualToConstant:cardHeight].active = YES;
    }
    return self;
}


-(void) getInputForButton:(id)sender {
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

        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action){
            
            NSString *card, *rank, *suit;
            card = alert.textFields[0].text;
            if (card.length >= 2) {
                rank = [nameDictionary objectForKey:[[card substringToIndex:card.length - 1] lowercaseString]];
                suit = [nameDictionary objectForKey:[[card substringFromIndex:card.length - 1] lowercaseString]];
                if (rank && suit) {
                    card = [NSString stringWithFormat:@"%@_of_%@", rank, suit];
//                    if (![cardsOnTable containsObject:card]) {
                    
                        [sender setBackgroundImage:[UIImage imageNamed:card] forState:UIControlStateNormal];
//                        [cardsOnTable addObject:card];
                        btn.currentCard = card;
//                    } else {
//                        //TODO
//                    }
                }
            }
                    
                                                   }];

        [alert addAction:ok];
        [alert addAction:cancel];

        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Input card, e.g. ah, ac ... 5d, 5s ... jd ";
            textField.keyboardType = UIKeyboardTypeDefault;
        }];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [sender setBackgroundImage:backImg forState:UIControlStateNormal];
        [sender setBackgroundColor:[UIColor whiteColor]];
//        [cardsOnTable removeObject:btn.currentCard];
        btn.currentCard = [NSNull null];
    }
    
}


@end
