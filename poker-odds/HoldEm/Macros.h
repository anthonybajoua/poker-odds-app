//
//  Macros.h
//  poker-odds
//
//  Created by Anthony Bajoua on 5/12/21.
//  Copyright © 2021 Anthony Bajoua. All rights reserved.
//


#ifdef DEBUG
#   define NSLog(...) NSLog(__VA_ARGS__)
#else
#   define NSLog(...) (void)0
#endif
