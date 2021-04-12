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

- (IBAction)removePlayer:(UIButton *)sender {
    if (numPlayers > kNumPlayersMin) {
        UIView *viewToRemove = [playerViews objectAtIndex:playerViews.count - 1];
        [viewToRemove removeFromSuperview];
        [playerViews removeLastObject];
        numPlayers--;
    }
}

- (IBAction)addPlayer:(UIButton *)sender {
    if (numPlayers < kNumPlayersMax) {
        [playerStackView addArrangedSubview:[self createPlayerView]];
        numPlayers++;
    }
}

- (IBAction)flop1:(UIButton *)sender {
    [self getInputForButton:sender];
}

- (IBAction)flop2:(UIButton *)sender {
    [self getInputForButton:sender];
}
- (IBAction)flop3:(UIButton *)sender {
    [self getInputForButton:sender];
}
- (IBAction)flop4:(UIButton *)sender {
    [self getInputForButton:sender];
}
- (IBAction)flop5:(UIButton *)sender {
    [self getInputForButton:sender];
}

CGFloat screenWidth, screenHeight;
UIStackView *playerStackView;
UIScrollView *playerScrollView;
NSMutableArray *playerViews;
NSMutableSet *cardsOnTable;
int numPlayers;
UIButton *currentButton;
UIImage *backImg;



- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNameDictionary];
    //Stack View
    playerViews = [NSMutableArray array];
    cardsOnTable = [NSMutableSet set];
    
    [self createPlayerScrollView];
    numPlayers = kNumPlayersDefault;
    [self.view addSubview:playerScrollView];
    
    [playerScrollView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:+200].active = YES;
    [playerScrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-100].active = YES;
    [playerScrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [playerScrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    
    backImg = [UIImage imageNamed:@"back"];
    
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
    [playerView.heightAnchor constraintEqualToConstant:cardHeight].active = YES;
    [playerView.widthAnchor constraintEqualToConstant:self.view.frame.size.width].active = YES;
    
    playerView.translatesAutoresizingMaskIntoConstraints = NO;
    [playerView setNeedsDisplay];
    
    
    UIButton *button1 = [self createCardButton];
    UIButton *button2 = [self createCardButton];

    [playerView addSubview:button1];
    [playerView addSubview:button2];

    
    [[button1.centerXAnchor constraintEqualToAnchor:playerView.centerXAnchor constant:-30] setActive:YES];
    [[button1.centerYAnchor constraintEqualToAnchor:playerView.centerYAnchor] setActive:YES];

    [[button2.centerYAnchor constraintEqualToAnchor:button1.centerYAnchor] setActive:YES];

    [[button2.leadingAnchor constraintEqualToAnchor:button1.trailingAnchor constant:30] setActive:YES];
    
    [playerViews addObject:playerView];
    return playerView;
}

-(UIButton *) createCardButton {
    UIButton *cardButton = [[CardButton alloc] init];
    [cardButton setBackgroundImage:backImg forState:UIControlStateNormal];
    [cardButton setBackgroundColor:[UIColor whiteColor]];
    [cardButton addTarget:self action:@selector(getInputForButton:) forControlEvents:UIControlEventTouchUpInside];
    cardButton.translatesAutoresizingMaskIntoConstraints = NO;
    [[cardButton.widthAnchor constraintEqualToConstant:cardWidth] setActive:YES];
    [[cardButton.heightAnchor constraintEqualToConstant:cardHeight] setActive:YES];
    currentButton = cardButton;
    return cardButton;
}

- (void) selectCard {
    NSLog(@"I WORK");
}

-(void) getInputForButton:(id)sender {
    CardButton *btn = (CardButton *) sender;
    if (!btn.currentCard) {
        UIAlertController *alert= [UIAlertController
                                      alertControllerWithTitle:@"Select card"
                                      message:@"Please select a card"
                                      preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action){
            
            NSString *card, *rank, *suit;
            card = alert.textFields[0].text;
            if (card.length >= 2) {
                rank = [[nameDictionary objectForKey:[card substringToIndex:card.length - 1]] lowercaseString];
                suit = [[nameDictionary objectForKey:[card substringFromIndex:card.length - 1]] lowercaseString];
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
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
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
        [cardsOnTable removeObject:btn.currentCard];
        btn.currentCard = nil;
    }
    
}

#pragma mark helpers

- (void)loadNameDictionary {

 nameDictionary = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:
                                                         @"ace", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"jack", @"queen", @"king", @"spades", @"clubs", @"diamonds", @"hearts", nil]
                                                forKeys:[NSArray arrayWithObjects:
                                                         @"a", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"j", @"q", @"k", @"s", @"c", @"d", @"h", nil]];
}


@end
