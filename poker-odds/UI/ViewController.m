//
//  ViewController.m
//  poker-odds
//
//  Created by Anthony Bajoua on 4/4/21.
//  Copyright © 2021 Anthony Bajoua. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()
@end


@implementation ViewController

UIHelper *uiHelper;

- (void)viewDidLoad {
    [super viewDidLoad];
    //Stack View
    
    uiHelper = [[UIHelper alloc] init];
    
    //create here so this is at the top of the responder chain.
    UIScrollView *playerScrollView = [[UIScrollView alloc] init];
    [self.view addSubview:playerScrollView];
    
    [uiHelper completePlayerScrollView:playerScrollView];
    
    [playerScrollView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:+200].active = YES;
    [playerScrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-100].active = YES;
    [playerScrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [playerScrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    
    [self.view reloadInputViews];
}


#pragma mark - Buttons

- (IBAction) clearCards:(UIButton *)sender {
    [uiHelper deleteCardsFromView:self.view];
}

- (IBAction) removePlayer:(UIButton *)sender {
    [uiHelper removePlayer];
}

- (IBAction) addPlayer:(UIButton *)sender {
    [uiHelper addPlayer];
}

- (IBAction) simulate:(UIButton *)sender {
    [uiHelper simulate];
    
}

- (IBAction)addCardToTable:(id)sender {
    [uiHelper getInputForButton:sender
                 withCompletion:
         ^(UIAlertController *alert) {
            [self presentViewController:alert animated:YES completion:nil];
        }
     ];
}

@end
