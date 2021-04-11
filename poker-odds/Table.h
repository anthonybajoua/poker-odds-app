#import <Foundation/Foundation.h>

@class Deck;

@interface Table : NSObject

@property NSUInteger numPlayers;
@property NSMutableArray *winTallies;
@property NSMutableArray *tieTallies;
@property Deck *deck;


- (id) initWithPlayers:(NSUInteger) players;

- (void) playGame;


@end
