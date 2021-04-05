//
//  Deck.m
//  poker-odds
//
//  Created by Anthony Bajoua on 4/4/21.
//  Copyright © 2021 Anthony Bajoua. All rights reserved.
//

#import "Deck.h"
#import "Constants.h"

@implementation Deck

const NSInteger DECKSIZE = 52;

NSMutableDictionary *cardMap;
int location;
uint8_t cards[52];


- (id) init {
    if ( self = [super init] ) {
        cardMap = [NSMutableDictionary dictionary];
        
        NSArray *suitStrings = @[@"s", @"h", @"d", @"c"];
        NSArray *rankStrings = @[@"A", @"K", @"Q", @"J", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];

        int count = 0;
        for (id rank in rankStrings) {
            for (id suit in suitStrings) {
                NSString *stringRep = [NSString stringWithFormat:@"%@%@", rank, suit];
                NSNumber *numberObject = [NSNumber numberWithInt:count];
                
                cards[count] = count;
                //two way mapping
                [cardMap setObject:numberObject forKey:stringRep];
                [cardMap setObject:stringRep forKey:numberObject];
                count++;
            }
        }
        

        [self shuffle];
        return self;
    }
    return nil;
    
}

- (void) shuffle {
    location = 52;
    for (int i = 51; i > 0; --i) {
        uint8_t temp = cards[i];
        int swapSpot = arc4random_uniform(i + 1);
        
        cards[i] = cards[swapSpot];
        cards[swapSpot] = temp;
    }
}

-(uint8_t) drawCard {
    return cards[location--];
}

- (NSString*) stringForCard:(uint8_t) num {
    return [cardMap objectForKey:[NSNumber numberWithInt:num]];
}

@end
