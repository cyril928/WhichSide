//
//  ChooseType.m
//  WhichSide
//
//  Created by Cyril Lee on 5/1/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "ChooseType.h"
#import "ChooseLevel.h"
#import "GameConfig.h"

@implementation ChooseType

- (void) playDigit {
    CCScene *chooseLevelScene = [CCBReader loadAsScene:@"ChooseLevel"];
    ChooseLevel *scene = (ChooseLevel *)chooseLevelScene.children.firstObject;
    GameConfig *g = [[GameConfig alloc] init];
    [g setTypeIndex:0];
    scene.g = g;
    [[CCDirector sharedDirector] replaceScene:[chooseLevelScene scene] withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.2]];
}

- (void) playLetter {
    CCScene *chooseLevelScene = [CCBReader loadAsScene:@"ChooseLevel"];
    ChooseLevel *scene = (ChooseLevel *)chooseLevelScene.children.firstObject;
    GameConfig *g = [[GameConfig alloc] init];
    [g setTypeIndex:1];
    scene.g = g;
    [[CCDirector sharedDirector] replaceScene:[chooseLevelScene scene] withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.2]];
}

- (void) playPicture {
    CCScene *chooseLevelScene = [CCBReader loadAsScene:@"ChooseLevel"];
    ChooseLevel *scene = (ChooseLevel *)chooseLevelScene.children.firstObject;
    GameConfig *g = [[GameConfig alloc] init];
    [g setTypeIndex:2];
    scene.g = g;
    [[CCDirector sharedDirector] replaceScene:[chooseLevelScene scene] withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.2]];
}

@end
