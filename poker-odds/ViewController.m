//
//  ViewController.m
//  poker-odds
//
//  Created by Anthony Bajoua on 4/4/21.
//  Copyright © 2021 Anthony Bajoua. All rights reserved.
//

#import "ViewController.h"

@interface CardButton : UIButton

@property NSString *currentCard;
@end

@implementation CardButton

-(id) init {
    if (self = [super init]) {
        return self;
    }
    return nil;
}

@end



@interface ViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *hi;

@end


@implementation ViewController

const int kNumPlayersDefault = 3;
const int kNumPlayersMax = 10;
const int kNumPlayersMin = 2;
const int cardHeight = 88;
const int cardWidth = 56;
static NSDictionary* nameDictionary = nil;


UIStackView *playerStackView;
UIScrollView *playerScrollView;
NSMutableArray *playerViews;
NSMutableSet *cardsOnTable;
int numPlayers = 0;
UIButton *currentButton;
UIImage *backImg;



- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNameDictionary];
    //Stack View
    playerViews = [NSMutableArray array];
    cardsOnTable = [NSMutableSet set];
    
    [self createPlayerScrollView];
    [self.view addSubview:playerScrollView];
    
    [playerScrollView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:+200].active = YES;
    [playerScrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-100].active = YES;
    [playerScrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [playerScrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    
    
    [self createPlayerStackView:kNumPlayersDefault];
    
    [self.view reloadInputViews];
    
}


-(void) createPlayerScrollView {
    playerScrollView = [[UIScrollView alloc] init];
    playerScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    playerScrollView.userInteractionEnabled = YES;
    [playerScrollView setNeedsDisplay];
}


- (void) createPlayerStackView:(NSInteger) numPlayers {
    playerStackView = [[UIStackView alloc] init];
    [playerScrollView addSubview:playerStackView];
    playerStackView.translatesAutoresizingMaskIntoConstraints = NO;
    playerStackView.axis = UILayoutConstraintAxisVertical;
    playerStackView.distribution = UIStackViewDistributionEqualSpacing;
    playerStackView.alignment = UIStackViewAlignmentCenter;
    playerStackView.spacing = 10;
    
    [playerStackView.topAnchor constraintEqualToAnchor:playerScrollView.topAnchor].active = YES;
    [playerStackView.bottomAnchor constraintEqualToAnchor:playerScrollView.bottomAnchor].active = YES;
    [playerStackView.leadingAnchor constraintEqualToAnchor:playerScrollView.leadingAnchor].active = YES;
    [playerStackView.trailingAnchor constraintEqualToAnchor:playerScrollView.trailingAnchor].active = YES;
    
    [playerStackView setNeedsDisplay];

    
    for (int i = 0; i < numPlayers; i++) {
        [playerStackView addArrangedSubview:[self createPlayerView]];
    }
}

- (UIView *) createPlayerView {
    UIView *playerView = [[UIView alloc] init];
    [playerView.heightAnchor constraintEqualToConstant:cardHeight + 20].active = YES;
    [playerView.widthAnchor constraintEqualToConstant:self.view.frame.size.width].active = YES;
    
    playerView.translatesAutoresizingMaskIntoConstraints = NO;
    [playerView setNeedsDisplay];
    
    
    UIButton *resetButton = [[UIButton alloc] init];
    [resetButton setImage:[UIImage systemImageNamed:@"clear"] forState:UIControlStateNormal];
    [resetButton addTarget:self action:@selector(resetCardsForPlayer:) forControlEvents:UIControlEventTouchUpInside];
    resetButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIButton *fold = [[UIButton alloc] init];
    [fold setImage:[UIImage systemImageNamed:@"f.square"] forState:UIControlStateNormal];
    [fold addTarget:self action:@selector(foldForPlayer:) forControlEvents:UIControlEventTouchUpInside];
    fold.translatesAutoresizingMaskIntoConstraints = NO;
    
    CardButton *button1 = [self createCardButton];
    CardButton *button2 = [self createCardButton];
    
    
    UITextField* playerId = [[UITextField alloc] init];
    UITextField* winPercentage = [[UITextField alloc] init];
    UITextField* tiePercentage = [[UITextField alloc] init];
    UITextField* equity = [[UITextField alloc] init];

    playerId.translatesAutoresizingMaskIntoConstraints = NO;
    winPercentage.translatesAutoresizingMaskIntoConstraints = NO;
    tiePercentage.translatesAutoresizingMaskIntoConstraints = NO;
    equity.translatesAutoresizingMaskIntoConstraints = NO;
    
    playerId.font = winPercentage.font = tiePercentage.font = equity.font = [UIFont fontWithName:@"Courier" size:12];
    
    
    
    [playerId setText:[NSNumber numberWithInt:++numPlayers].description];
    [winPercentage setText:@"Win %:"];
    [tiePercentage setText:@"Tie %:"];
    [equity setText:@"Equity %:"];

    [playerView addSubview:resetButton];
    [playerView addSubview:fold];
    [playerView addSubview:button1];
    [playerView addSubview:button2];
    [playerView addSubview:playerId];
    [playerView addSubview:winPercentage];
    [playerView addSubview:tiePercentage];
    [playerView addSubview:equity];

    [resetButton.leadingAnchor constraintEqualToAnchor:playerView.leadingAnchor constant:40].active = YES;
    [resetButton.centerYAnchor constraintEqualToAnchor:playerView.centerYAnchor constant:-15].active = YES;
    
    [fold.leadingAnchor constraintEqualToAnchor:playerView.leadingAnchor constant:40].active = YES;
    [fold.centerYAnchor constraintEqualToAnchor:playerView.centerYAnchor constant:15].active = YES;

    
    
    [playerId.centerYAnchor constraintEqualToAnchor:playerView.centerYAnchor].active = YES;
    [playerId.leadingAnchor constraintEqualToAnchor:playerView.leadingAnchor constant:15].active = YES;
    
    [winPercentage.centerYAnchor constraintEqualToAnchor:playerView.centerYAnchor constant:-15].active = YES;
    [winPercentage.trailingAnchor constraintEqualToAnchor:playerView.trailingAnchor constant:-35].active = YES;
    
    [tiePercentage.centerYAnchor constraintEqualToAnchor:playerView.centerYAnchor].active = YES;
    [tiePercentage.trailingAnchor constraintEqualToAnchor:playerView.trailingAnchor constant:-35].active = YES;
    
    [equity.centerYAnchor constraintEqualToAnchor:playerView.centerYAnchor constant:15].active = YES;
    [equity.trailingAnchor constraintEqualToAnchor:playerView.trailingAnchor constant:-35].active = YES;
    
    
    [button1.trailingAnchor constraintEqualToAnchor:playerView.centerXAnchor constant:-8].active = YES;
    [button1.centerYAnchor constraintEqualToAnchor:playerView.centerYAnchor].active = YES;

    [button2.centerYAnchor constraintEqualToAnchor:button1.centerYAnchor].active = YES;

    [button2.leadingAnchor constraintEqualToAnchor:button1.trailingAnchor constant:16].active = YES;
    
    [playerViews addObject:playerView];
    return playerView;
}

-(CardButton *) createCardButton {
    CardButton *cardButton = [[CardButton alloc] init];
    [cardButton setBackgroundImage:backImg forState:UIControlStateNormal];
    [cardButton setBackgroundColor:[UIColor whiteColor]];
    [cardButton addTarget:self action:@selector(getInputForButton:) forControlEvents:UIControlEventTouchUpInside];
    cardButton.translatesAutoresizingMaskIntoConstraints = NO;
    [cardButton.widthAnchor constraintEqualToConstant:cardWidth].active = YES;
    [cardButton.heightAnchor constraintEqualToConstant:cardHeight].active = YES;
    currentButton = cardButton;
    return cardButton;
}


-(void) getInputForButton:(id)sender {
    CardButton *btn = (CardButton *) sender;
    if (!btn.currentCard) {
        UIAlertController *alert= [UIAlertController
                                      alertControllerWithTitle:@"Select card"
                                      message:@"Please select a card"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];

        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action){
            
            NSString *card, *rank, *suit;
            card = alert.textFields[0].text;
            if (card.length >= 2) {
                rank = [nameDictionary objectForKey:[[card substringToIndex:card.length - 1] lowercaseString]];
                suit = [nameDictionary objectForKey:[[card substringFromIndex:card.length - 1] lowercaseString]];
                if (rank && suit) {
                    card = [NSString stringWithFormat:@"%@_of_%@", rank, suit];
                    if (![cardsOnTable containsObject:card]) {
                        [sender setBackgroundImage:[UIImage imageNamed:card] forState:UIControlStateNormal];
                        [cardsOnTable addObject:card];
                        btn.currentCard = card;
                    } else {
                        //TODO
                    }
                }
            }
                    
                                                   }];

        [alert addAction:ok];
        [alert addAction:cancel];

        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Input card, e.g. ah, ac ... 5d, 5s ... jd ";
            textField.keyboardType = UIKeyboardTypeDefault;
        }];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [sender setBackgroundImage:backImg forState:UIControlStateNormal];
        [sender setBackgroundColor:[UIColor whiteColor]];
        [cardsOnTable removeObject:btn.currentCard];
        btn.currentCard = [NSNull null];
    }
    
}


#pragma mark helpers

UIAlertController *alert;
UIAlertAction *cancel, *ok;

- (void)loadNameDictionary {

 nameDictionary = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:
                                                         @"ace", @"ace", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"10", @"jack", @"queen", @"king", @"spades", @"clubs", @"diamonds", @"hearts", nil]
                                                forKeys:[NSArray arrayWithObjects:
                                                         @"a", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"t", @"j", @"q", @"k", @"s", @"c", @"d", @"h", nil]];
}


#pragma mark - Buttons

- (IBAction) clearCards:(UIButton *)sender {
    [self deleteCardsFromView:self.view];
}

- (IBAction) removePlayer:(UIButton *)sender {
    if (numPlayers > kNumPlayersMin) {
        UIView *viewToRemove = [playerViews objectAtIndex:playerViews.count - 1];
        [self deleteCardsFromView:viewToRemove];
        [viewToRemove removeFromSuperview];
        [playerViews removeLastObject];
        numPlayers--;
    }
}

- (IBAction) addPlayer:(UIButton *)sender {
    if (numPlayers < kNumPlayersMax) {
        [playerStackView addArrangedSubview:[self createPlayerView]];
    }
}

- (IBAction)addCardToTable:(UIButton *)sender {
    [self getInputForButton:sender];
}





@end
