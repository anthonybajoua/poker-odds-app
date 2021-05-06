//
//  UIHelper.h
//  poker-odds
//
//  Created by Anthony Bajoua on 5/5/21.
//  Copyright © 2021 Anthony Bajoua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CardButton.h"

NS_ASSUME_NONNULL_BEGIN


/** This class is concerned with creating all subviews the main view needs.*/
@interface UIHelper : NSObject

@property (atomic, strong) UIStackView *playerStackView;
@property (atomic, strong) UIScrollView *playerScrollView;


- (UIView *) createPlayerScrollViewWithStackView:(UIStackView*) stackView;

- (void) deleteCardsFromView:(UIView*) view;



@end

NS_ASSUME_NONNULL_END
