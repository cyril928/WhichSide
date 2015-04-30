//
//  MissionAssign.m
//  WhichSide
//
//  Created by Cyril Lee on 4/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//
#import "Item.h"
#import "GamePlay.h"
#import "MissionAssign.h"
#import "TimeAnim.h"
#import "Stack.h"

#define ITEM_NUM    12
#define TIME    7

TimeAnim * _preTimeAnim;
@implementation MissionAssign {
    CCSprite *_leftBar;
    CCSprite *_rightBar;
    NSMutableSet *_usedItemSet;
    NSMutableArray *_usedItemList;
    float _barHeight;
    float _barWidth;
    CCNode *_timeBox;
    Stack *_stack;
}

- (void)didLoadFromCCB {
    _usedItemSet = [NSMutableSet set];
    _usedItemList = [NSMutableArray array];
}

- (void)onEnter {
    [super onEnter];
    NSLog(@"left bar is on %f, %f", _leftBar.position.x, _rightBar.position.y);
    NSLog(@"left bar length is %f", _leftBar.contentSize.width);
    NSLog(@"LEVEL is %d", self.levelIndex);
    
    _stack = [[Stack alloc] init];
    [self setupBar];
    [self selectItems];
    [self putItems];
    [self putTimeSquare];
    [self schedule:@selector(timeCountDown) interval:1.0f repeat:TIME delay:0];
    [self scheduleOnce:@selector(play) delay:TIME];
}

- (void) setupBar {
    _barHeight = _leftBar.contentSize.height;
    _barWidth = _leftBar.contentSize.width;
}

- (void) putTimeSquare {
    float unit = _timeBox.contentSize.width / (TIME + 1);
    for(int i = 0; i < TIME; i++) {
        TimeAnim* timeAnim = (TimeAnim *)[CCBReader load:@"TimeAnim"];
        timeAnim.position = ccp(unit * (i + 1) , _timeBox.contentSize.height / 2);
        [_timeBox addChild:timeAnim];
        [_stack push:timeAnim];
    }
}

- (void)putItems {
    float unit = _barHeight / (self.levelIndex + 1);
    int count = 0;
    for (id itemId in _usedItemList) {
        Item *item = [[Item alloc] initItem:[itemId intValue]];
        item.anchorPoint = ccp(0.5, 0.5);
        item.scaleX = 2.5;
        item.scaleY = 2.5;
        if(count < self.levelIndex) {
            item.position = ccp(_barWidth / 2, unit * (count + 1));
            [_leftBar addChild:item];
        }
        else {
            item.position = ccp(_barWidth / 2, unit * (count - self.levelIndex + 1));
            [_rightBar addChild:item];
        }
        count++;
    }

}

- (void)selectItems {
    int amount = self.levelIndex << 1;
    while(amount > 0) {
        int r = arc4random_uniform(ITEM_NUM) + 1;
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
    [[CCDirector sharedDirector] replaceScene:gamePlayScene];
}

- (void)reselect {
    [[CCDirector sharedDirector] replaceScene: [CCBReader loadAsScene:@"ChooseLevel"]];
}

- (void)start {
    CCScene *gamePlayScene = [CCBReader loadAsScene:@"GamePlay"];
    GamePlay *scene = (GamePlay *)gamePlayScene.children.firstObject;
    //[scene.usedItemList setArray:_usedItemList];
    scene.usedItemList = [[NSMutableArray alloc] initWithArray:_usedItemList];
    [[CCDirector sharedDirector] replaceScene:gamePlayScene];
}



@end
