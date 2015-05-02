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
    scene.g = self.g;
    [scene.g setLevelIndex:2];
    //[[CCDirector sharedDirector] replaceScene:missionAssignScene];
    [[CCDirector sharedDirector] replaceScene:[missionAssignScene scene] withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.2]];
}

- (void) level2 {
    CCScene *missionAssignScene = [CCBReader loadAsScene:@"MissionAssign"];
    MissionAssign *scene = (MissionAssign *)missionAssignScene.children.firstObject;
    scene.currentLevel = @"Level2";
    scene.g = self.g;
    [scene.g setLevelIndex:3];
    [[CCDirector sharedDirector] replaceScene:[missionAssignScene scene] withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.2]];
}

- (void) level3 {
    CCScene *missionAssignScene = [CCBReader loadAsScene:@"MissionAssign"];
    MissionAssign *scene = (MissionAssign *)missionAssignScene.children.firstObject;
    scene.currentLevel = @"Level3";
    scene.g = self.g;
    [scene.g setLevelIndex:4];
    [[CCDirector sharedDirector] replaceScene:[missionAssignScene scene] withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.2]];
}

- (void) level4 {
    CCScene *missionAssignScene = [CCBReader loadAsScene:@"MissionAssign"];
    MissionAssign *scene = (MissionAssign *)missionAssignScene.children.firstObject;
    scene.currentLevel = @"Level4";
    scene.g = self.g;
    [scene.g setLevelIndex:5];
    [[CCDirector sharedDirector] replaceScene:[missionAssignScene scene] withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.2]];
}

- (void)reselect {
    CCScene *chooseTypeScene = [CCBReader loadAsScene:@"ChooseType"];
    [[CCDirector sharedDirector] replaceScene:[chooseTypeScene scene] withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:0.2]];
    
    
}

@end
