//
//  MissionAssign.h
//  WhichSide
//
//  Created by Cyril Lee on 4/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "GameConfig.h"

@interface MissionAssign : CCNode

@property (nonatomic) GameConfig *g;
@property (nonatomic, strong) NSString* currentLevel;

@end
