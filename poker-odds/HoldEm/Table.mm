#import <Foundation/Foundation.h>
#import "Table.h"
#import "SevenEval.h"

/// External
const NSInteger kNumPlayersDefault = 3;
const NSInteger kNumPlayersMax = 10;
const NSInteger kNumPlayersMin = 2;

/// Internal
const int kMaxPlayers = 10;
const int kCardsPerHand = 2;
const int kCardsOnTable = 5;
const long kNumSimulationsDefault = 500000;
const uint_fast8_t kEmpty = UINT_FAST8_MAX;

@implementation Table : NSObject

//State for game
BOOL finishedSim;
uint_fast8_t tableCards[kCardsOnTable];
uint_fast8_t holeCards[kCardsPerHand*kMaxPlayers];

uint_fast8_t fixedHoleCards[kCardsPerHand*kMaxPlayers];
uint_fast8_t fixedTableCards[kCardsOnTable];

int winCounts[kMaxPlayers];
int tieCounts[kMaxPlayers];
int rankings[kMaxPlayers];

//Configuration for table
long numSimulations;
uint8_t numPlayers;
uint8_t numCardsOnTable;

- (instancetype) init {
    if ( self = [super init] ) {
        _deck = [[Deck alloc ]init];
        numPlayers = kNumPlayersDefault;
        numSimulations = kNumSimulationsDefault;
        
        for (int i = 0; i < kNumPlayersMax; i++) {
            holeCards[(2*i)] = kEmpty;
            holeCards[(2*i)+1] = kEmpty;
        }
        
        for (int i = 0; i < kCardsOnTable; i++) {
            tableCards[i] = kEmpty;
        }
        
        return self;
    }
    return nil;
}

- (NSArray *) simulate {
    
    for (int i = 0; i < numSimulations; i++) {
        [self playGame];
        [_deck shuffle];
    }
    NSArray *result =  [NSArray arrayWithObjects:[self getTiePercentages], [self getWinPercentages], nil];
    
    for (int i = 0; i < kCardsOnTable; i++) {
        if (!fixedTableCards[i]) {
            tableCards[i] = kEmpty;
        }
    }
    
    for (int i = 0; i < kNumPlayersMax * kCardsPerHand; i++) {
        if (!fixedHoleCards[i]) {
            holeCards[i] = kEmpty;
        }
    }
    
    for (int i = 0; i < kNumPlayersMax; i++) {
        tieCounts[i] = winCounts[i] = 0;
    }
    return result;
}

- (void) playGame {
    [self deal];
    [self flopRiverTurn];
    
//    [self logBoard];
//    [self logHands];
    
    
    //Get best hand ranking
    int best = -1;
    
    uint8_t count = 0;
    uint8_t numWinners = 0;
    
    for (int i = 0; i < numPlayers; i++) {
        uint8_t c6 = holeCards[count];
        uint8_t c7 = holeCards[count + 1];
        
        //Reset the cards that aren't fixed.
        if (!fixedHoleCards[count]) {
            holeCards[count] = kEmpty;
        }
        if (!fixedHoleCards[count+1]){
            holeCards[count+1] = kEmpty;
        }
        
        int handRanking = SevenEval::GetRank(tableCards[0], tableCards[1], tableCards[2], tableCards[3], tableCards[4], c6, c7);
        
        rankings[i] = handRanking;
        if (handRanking > best) {
            best = handRanking;
            numWinners = 1;
        } else if (handRanking == best) {
            numWinners++;
        }
        
        count += 2;
    }
    
    int *toModify;
    if (numWinners == 1) {
        toModify = winCounts;
    } else {
        toModify = tieCounts;
    }
    
    for (int i = 0; i < numPlayers; i++) {
        if (rankings[i] == best) {
            toModify[i] = toModify[i] + 1;
        }
    }
    
    for (int i = 0; i < kCardsOnTable; i++) {
        if (!fixedTableCards[i]) {
            tableCards[i] = kEmpty;
        }
    }
}

- (void) reset {
    [_deck reset];
    numCardsOnTable = 0;

    for (int i = 0; i < numPlayers; i++) {
        tieCounts[i] = 0;
        winCounts[i] = 0;
        holeCards[(2*i)] = kEmpty;
        holeCards[(2*i) + 1] = kEmpty;
    }
    tableCards[0] = tableCards[1] = tableCards[2] = tableCards[3] = tableCards[4] = kEmpty;
}


- (void) addPlayer {
    numPlayers++;
}

- (void) removePlayer {
    numPlayers--;
}

- (void) addCardToTable:(NSString *) card {
    [_deck removeFromDeck:card];
    NSInteger cardNum = [_deck getCardNumber:card];
    
    fixedTableCards[numCardsOnTable] = 1;
    tableCards[numCardsOnTable++] = cardNum;
}

- (void) removeCardFromTable:(NSString *) card {
    [_deck addToDeck:card];
    NSInteger cardNum = [_deck getCardNumber:card];
    for (int i = 0; i < kCardsOnTable; i++) {
        if (cardNum == tableCards[i]) {
            tableCards[i] = kEmpty;
            fixedTableCards[i] = 0;
        }
    }
}

- (void) addCard:(NSString *) card
          toHand:(NSInteger) hand {
    
    
    NSLog(@"Adding %@ to player %ld", card, (long)hand);
    
    if (holeCards[2*hand] == kEmpty) {
        NSLog(@"Adding to slot 1");
        [_deck removeFromDeck:card];
        holeCards[2*hand] = [_deck getCardNumber:card];
        fixedHoleCards[2*hand] = 1;
    } else if (holeCards[(2*hand)+1] == kEmpty) {
        NSLog(@"Adding to slot 2");
        [_deck removeFromDeck:card];
        holeCards[(2*hand) + 1] = [_deck getCardNumber:card];
        fixedHoleCards[(2*hand) + 1] = 1;
    }
    
}

- (void) removeCard:(NSString *) card
          fromHand:(NSInteger) hand {
    NSLog(@"Removing %@ from player %ld", card, (long)hand);

    uint_fast8_t target = [_deck getCardNumber:card];
    if (holeCards[2*hand] == target) {
        NSLog(@"Removing from slot 1");
        holeCards[(2*hand)] = kEmpty;
        fixedHoleCards[2*hand] = 0;

        [_deck addToDeck:card];
    } else if (holeCards[(2*hand)+1] == target) {
        NSLog(@"Removing from slot 2");
        fixedHoleCards[(2*hand) + 1] = 0;
        holeCards[(2*hand) + 1] = kEmpty;
        [_deck addToDeck:card];
    }
}

#pragma mark - Internal

- (NSArray *) getWinPercentages {
    NSMutableArray *winPercentages = [NSMutableArray array];
    for (int i = 0; i < numPlayers; i++)
    {
        [winPercentages addObject:@(100 * (winCounts[i] / (float) numSimulations))];
    }
    return winPercentages;
}

- (NSArray *) getTiePercentages {
    NSMutableArray *tiePercentages = [NSMutableArray array];
    for (int i = 0; i < numPlayers ; i++)
    {
        [tiePercentages addObject:@(100 * (tieCounts[i] / (float) numSimulations))];
    }
    return tiePercentages;
}

//Deals the cards to the table, ignoring the fixed cards.
- (void) deal {
    for (int i = 0; i < (kCardsPerHand * numPlayers); i++) {
        if (holeCards[i] == kEmpty) {
            holeCards[i] = [_deck drawCard];
        }
    }
}

//Does all the dealing in poker, does not burn cards yet.
- (void) flopRiverTurn {
    for (int i = 0; i < kCardsOnTable; i++) {
        if (tableCards[i] == kEmpty) {
            tableCards[i] = [_deck drawCard];
        }
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
