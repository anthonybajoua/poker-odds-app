//
//  Deck.m
//  poker-odds
//
//  Created by Anthony Bajoua on 4/4/21.
//  Copyright © 2021 Anthony Bajoua. All rights reserved.
//

#import "Deck.h"
#import "Constants.h"
#import "Macros.h"

@implementation Deck


NSMutableDictionary *nameToNumber, *numberToName;
int location;
int cardsLeft;

uint_fast8_t cards[52];

- (id) init {
    if ( self = [super init] ) {
        nameToNumber = [NSMutableDictionary dictionary];
        numberToName = [NSMutableDictionary dictionary];

        
        NSArray *ranks = @[@"ace", @"king", @"queen", @"jack", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
        NSArray *suits = @[@"spades", @"hearts", @"diamonds", @"clubs"];
        
        uint8_t count = 0;
        
        for (id rank in ranks) {
            for (id suit in suits) {
                
                cards[count] = count;
                
                
                NSNumber *cardValue = [NSNumber numberWithInt:count];
                NSString *cardName = [NSString stringWithFormat:@"%@_of_%@", rank, suit];
                                
                [numberToName setValue:cardName forKey:cardValue.description];
                [nameToNumber setValue:cardValue forKey:cardName];
                count++;

            }
        }
        location = cardsLeft = 51;
        [self shuffle];
        return self;
    }
    return nil;
    
}

- (void) shuffle {
    location = cardsLeft;
    for (int i = location; i > 0; --i) {
        int swapSpot = arc4random_uniform(i + 1);
        
        uint8_t temp = cards[i];
        cards[i] = cards[swapSpot];
        cards[swapSpot] = temp;
    }
}

- (void) reset {
    location = 51;
    [self shuffle];
}

-(uint8_t) drawCard {
    return cards[location--];
}

- (NSString*) getCardName:(uint8_t) num {
    return [numberToName objectForKey:[NSNumber numberWithInt:num].description];
}

- (NSInteger) getCardNumber:(NSString *) name {
    return [[nameToNumber objectForKey:name] longValue];
}

-(void) removeFromDeck:(NSString *)name {
    NSInteger target = [self getCardNumber:name];
    
    if (target >= 0 && target <= 51) {
        for (int i = 0; i < 52; i++){
            if (cards[i] == target) {
                uint8_t tmp = cards[cardsLeft];
                cards[cardsLeft] = target;
                cards[i] = tmp;
            }
        }
    }
    cardsLeft--;

}


-(void) addToDeck:(NSString *)name {
    NSInteger target = [self getCardNumber:name];
    if (target >= 0 && target <= 51) {
        for (int i = location; i < 52; i++){
            if (cards[i] == target) {
                uint8_t tmp = cards[location + 1];
                cards[location + 1] = cards[i];
                cards[i] = tmp;
            }
        }
    }
    cardsLeft++;
}

@end
