#import <Foundation/Foundation.h>
#import "Table.h"
//Must import here b/c it's a  C++ file
#import "SevenEval.h"


//External
const NSInteger kNumPlayersDefault = 3;
const NSInteger kNumPlayersMax = 10;
const NSInteger kNumPlayersMin = 2;

//Internal
const int kMaxPlayers = 10;
const int kCardsPerHand = 2;
const int kCardsOnTable = 5;
const long kNumSimulationsDefault = 500000;
const long kDefaultPlayers = 3;


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
BOOL finishedSim;

uint8_t tableCards[kCardsOnTable];
uint8_t holeCards[kCardsPerHand*kMaxPlayers];

int winCounts[kMaxPlayers];
int tieCounts[kMaxPlayers];

long numSimulations = kNumSimulationsDefault;
uint8_t numPlayers = kDefaultPlayers;

- (instancetype) init {
    if ( self = [super init] ) {
        _deck = [[Deck alloc ]init];
        [self deal];
        return self;
    }
    return nil;
}

- (void) playGame {
    if (!didFlop) [self doFlop];
    if (!didTurn) [self doTurn];
    if (!didRiver) [self doRiver];
    
    [self logBoard];
    [self logHands];
    
    int rankings[10];
    
    //Get best hand ranking
    int best = -1;
    
    uint8_t count = 0;
    uint8_t numWinners = 0;
    
    for (int i = 0; i < numPlayers; i++) {
        uint8_t c6 = holeCards[count++];
        uint8_t c7 = holeCards[count++];
        
        int handRanking = SevenEval::GetRank(tableCards[0], tableCards[1], tableCards[2], tableCards[3], tableCards[4], c6, c7);
        
        rankings[i] = handRanking;
        if (handRanking > best) {
            best = handRanking;
            numWinners = 1;
        } else if (handRanking == best) {
            numWinners++;
        }
    }
        
    if (numWinners == 1) {
        for (int i = 0; i < numPlayers; i++) {
            winCounts[i]++;
        }
    } else {
        for (int i = 0; i < numPlayers; i++) {
            tieCounts[i]++;
        }
    }
    
    [_deck shuffle];
    didRiver = didFlop = didTurn = NO;
    [self deal];
}

- (NSArray *) getWinPercentages {
    NSMutableArray *winPercentages = [NSMutableArray array];
    for (int i = 0; i < numPlayers; i++)
    {
        [winPercentages addObject:@(winCounts[i] / (float) numSimulations)];
    }
    return winPercentages;
}

- (NSArray *) getTiePercentages {
    NSMutableArray *tiePercentages = [NSMutableArray array];
    for (int i = 0; i < numPlayers ; i++)
    {
        [tiePercentages addObject:@(winCounts[i] / (float) numSimulations)];
    }
    return tiePercentages;
}

- (void) reset {
    [_deck shuffle];
    didRiver = didFlop = didTurn = NO;

    for (int i = 0; i < numPlayers; i++) {
        tieCounts[i] = 0;
        winCounts[i] = 0;
    }
    
    [self deal];
}


#pragma mark - Helpers

- (void) deal {
    for (int i = 0; i < (kCardsPerHand * numPlayers); i++) {
        holeCards[i++] = [_deck drawCard];
        holeCards[i++] = [_deck drawCard];
    }
}

- (void) doFlop {
    if (!didFlop) {
        [_deck drawCard];
        tableCards[0] = [_deck drawCard];
        tableCards[1] = [_deck drawCard];
        tableCards[2] = [_deck drawCard];
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

- (void) logBoard {
    NSString *s0, *s1, *s2, *s3, *s4;
    s0 = [_deck getCardName:tableCards[0]];
    s1 = [_deck getCardName:tableCards[1]];
    s2 = [_deck getCardName:tableCards[2]];
    s3 = [_deck getCardName:tableCards[3]];
    s4 = [_deck getCardName:tableCards[4]];
    NSLog(@"TABLE CARDS: %@ %@ %@ %@ %@", s0, s1, s2, s3, s4);
}

- (void) logHands {
    int count = 0;
    for (int i = 0; i < numPlayers; i++) {
        NSString *card0 = [_deck getCardName:holeCards[count++]];
        NSString *card1 = [_deck getCardName:holeCards[count++]];
        NSLog(@"Player %d : %@ %@", i, card0, card1);
    }
}

@end
