//
//  Deck.h
//  poker-odds
//
//  Created by Anthony Bajoua on 4/4/21.
//  Copyright © 2021 Anthony Bajoua. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Deck : NSObject

/** All cards here are of the format %s-of-%s. e.g. king-of-spades (case insensitive). */

/**Shuffle the deck pseudorandomly, including adding all cards back in*/
- (void) shuffle;

/**Return the topmost card*/
- (uint8_t) drawCard;

/**Gets the card name from the card number*/
- (NSString*) getCardName:(uint8_t) num;

/**Gets  the card number of the card name.*/
- (NSInteger) getCardNumber:(NSString *) name;

/** Removes the card from the deck,.
 */
- (void) removeFromDeck:(NSString *)card;


@end


NS_ASSUME_NONNULL_END
