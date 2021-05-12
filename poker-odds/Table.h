#import <Foundation/Foundation.h>

@class Deck;

@interface Table : NSObject

@property Deck *deck;

- (instancetype) init:(NSUInteger) players;

- (void) playGame;

- (void) setNumSimulations:(NSInteger)sims;

- (NSArray *) getWinPercentages;

- (NSArray *) getTiePercentages;

@end
