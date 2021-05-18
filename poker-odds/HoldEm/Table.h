#import <Foundation/Foundation.h>

#import "Table.h"
#import "Deck.h"
/** Implementation of Texas Hold Em.
 */
@class Deck;

@interface Table : NSObject

const extern NSInteger kNumPlayersDefault;
const extern NSInteger kNumPlayersMax;
const extern NSInteger kNumPlayersMin;

@property Deck *deck;
@property NSInteger numSimulations;

/** Plays one game at the table.
 */
- (void) playGame;

/** Gets the win percentages for the number of simulations set. Won't rerun unless table is reset
 */
- (NSArray *) getWinPercentages;

/** Gets the tie percentages for the number of simulations set. Won't rerun unless table is reset
 */
- (NSArray *) getTiePercentages;

/** Gets the tie percentages for the number of simulations set. Won't rerun unless table is reset
 */
- (void) reset;

@end
