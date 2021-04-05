#import <Foundation/Foundation.h>

@class Deck;

@interface Table : NSObject

@property NSUInteger numPlayers;
@property Deck *deck;


- (id) initWithPlayers:(NSUInteger) players;

- (void) playGame;


@end
