//
//  Deck.h
//  poker-odds
//
//  Created by Anthony Bajoua on 4/4/21.
//  Copyright © 2021 Anthony Bajoua. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Deck : NSObject

@property NSInteger size;

- (id) init;
- (void) shuffle;
- (uint8_t) drawCard;
- (NSString*) stringForCard:(uint8_t) num;

@end


NS_ASSUME_NONNULL_END
