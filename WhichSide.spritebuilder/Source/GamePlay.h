//
//  GamePlay.h
//  WhichSide
//
//  Created by Cyril Lee on 4/23/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "GameConfig.h"

@interface GamePlay : CCNode <CCPhysicsCollisionDelegate>

@property (nonatomic) GameConfig *g;
@property (nonatomic, copy) NSMutableArray *usedItemList;

@end
