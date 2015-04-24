//
//  GamePlay.m
//  WhichSide
//
//  Created by Cyril Lee on 4/23/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GamePlay.h"

#define SIDES 2

@implementation GamePlay {
    
}

- (void)didLoadFromCCB {
    
}

- (void)onEnter {
    [super onEnter];
    for (id item in self.usedItemList) {
        NSLog(@"%@", item);
    }
}

@end
