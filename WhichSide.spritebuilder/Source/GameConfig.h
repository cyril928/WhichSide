//
//  GameConfig.h
//  WhichSide
//
//  Created by Cyril Lee on 5/1/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

@interface GameConfig : NSObject

- (void)setMainItem:(Item *)i;

- (Item *)getMainItem;

- (void)setTypeIndex:(int)t;

- (int)getTypeIndex;

- (void)setLevelIndex:(int)l;

- (int)getLevelIndex;

- (int)getTypeAmount;

- (int)getTypeScore;

- (int)getTypeTime;

- (int)get5ComboScore;

- (int)get10ComboScore;

- (Item *)getItem:(int)id;

@end
