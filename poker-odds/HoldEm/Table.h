#import <Foundation/Foundation.h>
#import "Table.h"
#import "Deck.h"

/** Implementation of Texas Hold Em.*/
@class Deck;

@interface Table : NSObject

const extern NSInteger kNumPlayersDefault;
const extern NSInteger kNumPlayersMax;
const extern NSInteger kNumPlayersMin;

@property Deck *deck;
@property NSInteger numSimulations;
@property NSMutableArray *equities;
@property NSMutableArray *ties;
@property NSMutableArray *wins;
@property NSMutableSet *cardsOnTable;

/**Simulates numSimulations games at the table at the given state. Returns an array of two arrays, the win counts and tie tie counts.*/
- (NSArray*) simulate;

/** Resets the table's and decks state*/
- (void) reset;

/** Adds a player to the table.*/
- (void) addPlayer;

/** Remove a player from the table.*/
- (void) removePlayer;

/**Remove said card from deck and add it to the table.*/
- (void) addCardToTable:(NSString *) card;

/**Remove said card from table and add it to the deck.*/
- (void) removeCardFromTable:(NSString *) card;

/**Remove said card from the deck and add it to the player number (0 index) hand.*/
- (void) addCard:(NSString *) card
          toHand:(NSInteger) playerHand;

/**Remove said card from a players hand and adds to deck. Shuffles the deck.*/
- (void) removeCard:(NSString *) card
           fromHand:(NSInteger) hand;

@end
