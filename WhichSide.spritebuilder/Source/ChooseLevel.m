//
//  ChooseLevel.m
//  WhichSide
//
//  Created by Cyril Lee on 4/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "ChooseLevel.h"
#import "MissionAssign.h"

@implementation ChooseLevel

- (void) level1 {
    CCScene *missionAssignScene = [CCBReader loadAsScene:@"MissionAssign"];
    MissionAssign *scene = (MissionAssign *)missionAssignScene.children.firstObject;
    scene.currentLevel = @"Level1";
    scene.levelIndex = 1;
    [[CCDirector sharedDirector] replaceScene:missionAssignScene];
}

- (void) level2 {
    CCScene *missionAssignScene = [CCBReader loadAsScene:@"MissionAssign"];
    MissionAssign *scene = (MissionAssign *)missionAssignScene.children.firstObject;
    scene.currentLevel = @"Level2";
    scene.levelIndex = 2;
    [[CCDirector sharedDirector] replaceScene:missionAssignScene];
}

- (void) level3 {
    CCScene *missionAssignScene = [CCBReader loadAsScene:@"MissionAssign"];
    MissionAssign *scene = (MissionAssign *)missionAssignScene.children.firstObject;
    scene.currentLevel = @"Level3";
    scene.levelIndex = 3;
    [[CCDirector sharedDirector] replaceScene:missionAssignScene];
}

- (void) level4 {
    CCScene *missionAssignScene = [CCBReader loadAsScene:@"MissionAssign"];
    MissionAssign *scene = (MissionAssign *)missionAssignScene.children.firstObject;
    scene.currentLevel = @"Level4";
    scene.levelIndex = 4;
    [[CCDirector sharedDirector] replaceScene:missionAssignScene];
}



@end
