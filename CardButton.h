//
//  CardButton.h
//  poker-odds
//
//  Created by Anthony Bajoua on 5/5/21.
//  Copyright © 2021 Anthony Bajoua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

extern const int cardWidth;
extern const int cardHeight;

/**Simple UIButton with a variable for the current card it contains.*/
@interface CardButton : UIButton

@property (strong, nullable) NSString *currentCard;

-(void) setAction;

@end


