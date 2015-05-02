//
//  MissionAssign.m
//  WhichSide
//
//  Created by Cyril Lee on 4/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//
#import "Item.h"
#import "GamePlay.h"
#import "ChooseLevel.h"
#import "MissionAssign.h"
#import "TimeAnim.h"
#import "Stack.h"

#define RAND_TIME   1

TimeAnim * _preTimeAnim;
int LEVEL_INDEX;
int TYPE_INDEX;
int ITEM_NUM;
int REMEM_TIME;
@implementation MissionAssign {
    CCSprite *_leftBar;
    CCSprite *_rightBar;
    NSMutableSet *_usedItemSet;
    NSMutableArray *_usedItemList;
    NSMutableArray *_randomShowList;
    float _barHeight;
    float _barWidth;
    CCNode *_timeBox;
    Stack *_stack;
}

- (void)didLoadFromCCB {
    _usedItemSet = [NSMutableSet set];
    _usedItemList = [NSMutableArray array];
    _randomShowList = [NSMutableArray array];
}

- (void)onEnter {
    [super onEnter];
    
    LEVEL_INDEX = [self.g getLevelIndex];
    TYPE_INDEX = [self.g getTypeIndex];
    ITEM_NUM = [self.g getTypeAmount];
    REMEM_TIME = [self.g getTypeTime];
    
    _stack = [[Stack alloc] init];
    [self setupBar];
    [self selectItems];
    [self putTimeSquare];
    [self putRandomItemShow];
    [self scheduleOnce:@selector(removeItemRandomShow) delay:RAND_TIME];
    [self scheduleOnce:@selector(putItems) delay:RAND_TIME];
    [self schedule:@selector(timeCountDown) interval:1.0f repeat:REMEM_TIME delay:RAND_TIME];
    [self scheduleOnce:@selector(play) delay:REMEM_TIME + RAND_TIME];
}

- (void) setupBar {
    _barHeight = _leftBar.contentSize.height;
    _barWidth = _leftBar.contentSize.width;
}

- (void) putTimeSquare {
    float unit = _timeBox.contentSize.width / (REMEM_TIME + 1);
    for(int i = 0; i < REMEM_TIME; i++) {
        TimeAnim* timeAnim = (TimeAnim *)[CCBReader load:@"TimeAnim"];
        timeAnim.position = ccp(unit * (i + 1) , _timeBox.contentSize.height / 2);
        [_timeBox addChild:timeAnim];
        [_stack push:timeAnim];
    }
}

- (void)putRandomItemShow {
    float unit = _barHeight / (LEVEL_INDEX + 1);
    for(int i = 0; i < LEVEL_INDEX; i++) {
        CCParticleSystem *ps = (CCParticleSystem *)[CCBReader load:@"ItemRandomShow"];
        //ps.autoRemoveOnFinish = TRUE;
        ps.position = ccp(_barWidth / 2, unit * (i + 1));
        [_leftBar addChild:ps];
        [_randomShowList addObject:ps];
    }
    for(int i = 0; i < LEVEL_INDEX; i++) {
        CCParticleSystem *ps = (CCParticleSystem *)[CCBReader load:@"ItemRandomShow"];
        //ps.autoRemoveOnFinish = TRUE;
        ps.position = ccp(_barWidth / 2, unit * (i + 1));
        [_rightBar addChild:ps];
        [_randomShowList addObject:ps];
    }
    
}

- (void)removeItemRandomShow {
    for(CCParticleSystem *ps in _randomShowList) {
        [ps removeFromParent];
        [ps stopAllActions];
    }
}

- (void)putItems {
    float unit = _barHeight / (LEVEL_INDEX + 1);
    int count = 0;
    for (id itemId in _usedItemList) {
        Item *item = [self.g getItem:[itemId intValue]];
        item.anchorPoint = ccp(0.5, 0.5);
        item.scale = [self.g getShowItemScale];
        if(count < LEVEL_INDEX) {
            item.position = ccp(_barWidth / 2, unit * (count + 1));
            [_leftBar addChild:item];
        }
        else {
            item.position = ccp(_barWidth / 2, unit * (count - LEVEL_INDEX + 1));
            [_rightBar addChild:item];
        }
        count++;
    }

}

- (void)selectItems {
    int amount = LEVEL_INDEX << 1;
    while(amount > 0) {
        int r = arc4random_uniform(ITEM_NUM);
        if(![_usedItemSet containsObject:@(r)]) {
            amount--;
            [_usedItemSet addObject:@(r)];
            [_usedItemList addObject:@(r)];
        }
    }
    for (id item in _usedItemList) {
        NSLog(@"%@", item);
    }
}

- (void)timeCountDown {
    if(_preTimeAnim != nil) {
        [_preTimeAnim removeFromParent];
    }
    TimeAnim *timeAnim = [_stack pop];
    _preTimeAnim = timeAnim;
    [timeAnim startTimeSquare];
}

- (void)play {
    CCScene *gamePlayScene = [CCBReader loadAsScene:@"GamePlay"];
    GamePlay *scene = (GamePlay *)gamePlayScene.children.firstObject;
    scene.usedItemList = [[NSMutableArray alloc] initWithArray:_usedItemList];
    scene.g = self.g;
    [[CCDirector sharedDirector] replaceScene:gamePlayScene];
}

- (void)reselect {
    CCScene *chooseLevelScene = [CCBReader loadAsScene:@"ChooseLevel"];
    ChooseLevel *scene = (ChooseLevel *)chooseLevelScene.children.firstObject;
    scene.g = self.g;
    [[CCDirector sharedDirector] replaceScene:[chooseLevelScene scene] withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:0.2]];
}

- (void)start {
    CCScene *gamePlayScene = [CCBReader loadAsScene:@"GamePlay"];
    GamePlay *scene = (GamePlay *)gamePlayScene.children.firstObject;
    //[scene.usedItemList setArray:_usedItemList];
    scene.usedItemList = [[NSMutableArray alloc] initWithArray:_usedItemList];
    scene.g = self.g;
    [[CCDirector sharedDirector] replaceScene:gamePlayScene];
}



@end
