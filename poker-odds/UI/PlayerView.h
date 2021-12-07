//
//  PlayerView.h
//  poker-odds
//
//  Created by Anthony on 12/6/21.
//  Copyright © 2021 Anthony Bajoua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class Table;

@interface PlayerView : UIView

@property NSInteger *playerId;
@property UITextView *winPercent;
@property UITextView *tiePercent;
@property UITextView *equityPercent;

- (instancetype) initWithId:(NSInteger) num andTable:(Table *) table;

@end

NS_ASSUME_NONNULL_END
