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


NSMutableDictionary *nameToNumber, *numberToName;
int location;
uint_fast32_t cards[52];

- (id) init {
    if ( self = [super init] ) {
        nameToNumber = [NSMutableDictionary dictionary];
        numberToName = [NSMutableDictionary dictionary];

        
        NSDictionary<NSString *, NSNumber *> *ranks = @{
            @"A": @ACE,
            @"K": @KING,
            @"Q": @QUEEN,
            @"10": @TEN,
            @"9": @NINE,
            @"8": @EIGHT,
            @"7": @SEVEN,
            @"6": @SIX,
            @"5": @FIVE,
            @"4": @FOUR,
            @"3": @THREE,
            @"2": @TWO
        };
        
        NSDictionary<NSString *, NSNumber *> *suits = @{
            @"SPADES": @SPADE,
            @"HEARTS": @HEART,
            @"DIAMONDS": @DIAMOND,
            @"CLUBS": @CLUB
        };
        
        for (id rank in [ranks allKeys]) {
            for (id suit in [suits allKeys]) {
                
                uint_fast32_t cardNum = [[ranks objectForKey:rank] intValue] + ([[suits objectForKey:suit] intValue] << FLUSH_BIT_SHIFT);
                
                NSNumber *cardValue = [NSNumber numberWithInt:cardNum];
                
                
                NSString *cardName = [NSString stringWithFormat:@"%@ of %@", rank, suit];
                                
                [numberToName setValue:cardName forKey:cardValue.description];
                [nameToNumber setValue:cardValue forKey:cardName];

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
        int swapSpot = arc4random_uniform(i + 1);
        
        uint8_t temp = cards[i];
        cards[i] = cards[swapSpot];
        cards[swapSpot] = temp;
    }
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

-(void) removeCard:(NSString *)name {
    if ([self getCardNumber:name]) {
        for (int i = 0; i < 52; i++){
            if (cards[i] == [self getCardNumber:name]) {
                uint_fast32_t tmp = cards[location];
                cards[location] = cards[i];
                cards[i] = tmp;
                location--;
            }
        }
    }
}

@end
