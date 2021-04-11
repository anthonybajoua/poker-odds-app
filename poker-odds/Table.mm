#import <Foundation/Foundation.h>
#import "Table.h"
#import "Deck.h"
#import "SKPokerEval/SevenEval.h"


@implementation Table : NSObject

typedef NS_ENUM(NSUInteger, HandRanking) {
    kHighCard,
    kPair,
    kTwoPair,
    kThreeOfAKind,
    kStraight,
    kFlush,
    kFullHouse,
    kFourOfAKind,
    kStraightFlush,
    kRoyalFlush
};


BOOL didFlop;
BOOL didTurn;
BOOL didRiver;

NSMutableArray *kickers;
NSMutableArray *handRankings;

uint8_t tableCards[5];
uint8_t holeCards[20];



- (id) initWithPlayers:(NSUInteger) players {
    if ( self = [super init] ) {
        _numPlayers = players;
        _deck = [[Deck alloc ]init];
        _winTallies = [NSMutableArray arrayWithCapacity:_numPlayers];
        [self deal];
        return self;
    }
    return nil;
}

- (void) deal {
    int count = 0;
    for (int i = 0; i < _numPlayers; i++) {
        holeCards[count++] = [_deck drawCard];
        holeCards[count++] = [_deck drawCard];
    }
    
}

- (void) doFlop {
    if (!didFlop) {
        [_deck drawCard];
        for (int i = 0; i < 3; i++) {
            tableCards[i] = [_deck drawCard];
        }
    }
}

- (void) doTurn {
    if (!didTurn) {
        [_deck drawCard];
        tableCards[3] = [_deck drawCard];
        didTurn = YES;
    }
}

- (void) doRiver {
    if (!didRiver) {
        [_deck drawCard];
        tableCards[4] = [_deck drawCard];
        didRiver = YES;
    }
}

- (void) playGame {
    if (!didFlop) [self doFlop];
    if (!didTurn) [self doTurn];
    if (!didRiver) [self doRiver];
    
    
    uint8_t c1, c2, c3, c4, c5, c6, c7;
    c1 = tableCards[0];
    c2 = tableCards[1];
    c3 = tableCards[2];
    c4 = tableCards[3];
    c5 = tableCards[4];

    
    [self logBoard];
    [self logHands];
    
    NSMutableDictionary *scores = [NSMutableDictionary dictionary];

    int count = 0;
    for (int i = 0; i < _numPlayers; i++) {
        c6 = holeCards[count++];
        c7 = holeCards[count++];
        
        NSValue *handRanking = [NSNumber numberWithUnsignedInt:SevenEval::GetRank(c1, c2, c3, c4, c5, c6, c7)];
        NSValue *player = [NSNumber numberWithInt:i];
        
        if (NSMutableArray *playersWithScore = [scores objectForKey:handRanking.description]) {
            [playersWithScore addObject:player];
        } else {
            [scores setValue:[NSMutableArray arrayWithObject:player] forKey:handRanking.description];
        }
    }
    
    NSArray *winners = [scores objectForKey:[[scores allKeys] valueForKeyPath:@"@max.self"]];
        
    
    [_deck shuffle];
    didRiver = didFlop = didTurn = NO;
    [self deal];
}

- (void) logBoard {
    NSString *s1, *s2, *s3, *s4, *s5;
    s1 = [_deck stringForCard:tableCards[0]];
    s2 = [_deck stringForCard:tableCards[1]];
    s3 = [_deck stringForCard:tableCards[2]];
    s4 = [_deck stringForCard:tableCards[3]];
    s5 = [_deck stringForCard:tableCards[4]];
    NSLog(@"TABLE CARDS: %@ %@ %@ %@ %@", s1, s2, s3, s4, s5);
}

- (void) logHands {
    int count = 0;
    for (int i = 0; i < _numPlayers; i++) {
        NSString *card0 = [_deck stringForCard:holeCards[count++]];
        NSString *card1 = [_deck stringForCard:holeCards[count++]];
        NSLog(@"Player %d : %@ %@", i, card0, card1);
    }
}

-(void) reset {
    [_deck shuffle];
    didRiver = didFlop = didTurn = NO;
    [self deal];
}


@end


