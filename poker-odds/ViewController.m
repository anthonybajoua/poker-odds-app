//
//  ViewController.m
//  poker-odds
//
//  Created by Anthony Bajoua on 4/4/21.
//  Copyright © 2021 Anthony Bajoua. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *hi;

@end


@implementation ViewController

const int kNumPlayersDefault = 3;
const int kNumPlayersMax = 10;
const int kNumPlayersMin = 2;
const int cardHeight = 88;
const int cardWidth = 56;



- (IBAction)removePlayer:(id)sender {
    if (numPlayers > kNumPlayersMin) {
        UIView *viewToRemove = [playerViews objectAtIndex:playerViews.count - 1];
        [viewToRemove removeFromSuperview];
        [playerViews removeLastObject];
        numPlayers--;
    }
}

- (IBAction)addPlayer:(id)sender {
    if (numPlayers < kNumPlayersMax) {
        [playerStackView addArrangedSubview:[self createPlayerView]];
        numPlayers++;
    }
}

- (IBAction)flop1:(UIButton *)sender {
}

- (IBAction)flop2:(UIButton *)sender {
}
- (IBAction)flop3:(UIButton *)sender {
}
- (IBAction)flop4:(UIButton *)sender {
}
- (IBAction)flop5:(UIButton *)sender {
}

CGFloat screenWidth, screenHeight;
UIStackView *playerStackView;
UIScrollView *playerScrollView;
NSMutableArray *playerViews;
int numPlayers;


- (void)viewDidLoad {
    [super viewDidLoad];
    //Stack View
    playerViews = [NSMutableArray array];
    
    [self createPlayerScrollView];
    numPlayers = kNumPlayersDefault;
    [self.view addSubview:playerScrollView];
    
    [playerScrollView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:+200].active = YES;
    [playerScrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-100].active = YES;
    [playerScrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [playerScrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    
    [self createPlayerStackView:3];
    
    [self.view reloadInputViews];
    
}


-(void) createPlayerScrollView {
    playerScrollView = [[UIScrollView alloc] init];
    playerScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    playerScrollView.userInteractionEnabled = YES;
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
    
//    [playerStackView.centerXAnchor constraintEqualToAnchor:playerScrollView.centerXAnchor].active = YES;
//    [playerStackView.centerYAnchor constraintEqualToAnchor:playerScrollView.centerYAnchor].active = YES;
    
    for (int i = 0; i < numPlayers; i++) {
        [playerStackView addArrangedSubview:[self createPlayerView]];
    }
}

- (UIView *) createPlayerView {
    UIView *playerView = [[UIView alloc] init];
    [playerView.heightAnchor constraintEqualToConstant:cardHeight].active = YES;
    [playerView.widthAnchor constraintEqualToConstant:self.view.frame.size.width].active = YES;
    
    playerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    
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
    UIButton *cardButton = [UIButton systemButtonWithImage:[UIImage imageNamed:@"back"] target:self action:@selector(selectCard)];
    [cardButton addTarget:self action:@selector(selectCard) forControlEvents:UIControlEventTouchUpInside];
    cardButton.translatesAutoresizingMaskIntoConstraints = NO;
    [[cardButton.widthAnchor constraintEqualToConstant:cardWidth] setActive:YES];
    [[cardButton.heightAnchor constraintEqualToConstant:cardHeight] setActive:YES];
    return cardButton;
}

- (void) selectCard {
    NSLog(@"I WORK");
}



@end
