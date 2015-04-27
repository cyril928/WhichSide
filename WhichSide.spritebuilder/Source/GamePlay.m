//
//  GamePlay.m
//  WhichSide
//
//  Created by Cyril Lee on 4/23/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Math.h"
#import "GamePlay.h"
#import "Item.h"
#import "Queue.h"
#import "CCPhysics+ObjectiveChipmunk.h"

#define M_PI        3.14159265358979323846264338327950288
#define SIDES 2
#define ITEM_SPEED_DIFF_RANGE 20

static const double SWIPE_SPEED = 100;
float init_x, init_y;
float next_x, next_y;
@implementation GamePlay {
    CCPhysicsNode *_physicsNode;
    CCSprite *_activeZone;
    Queue *_queue;
}

- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    _physicsNode.collisionDelegate = self;
}

- (void)onEnter {
    [super onEnter];
    for (id item in self.usedItemList) {
        NSLog(@"%@", item);
    }
    _queue = [[Queue alloc] init];
    [self startFallDownItem];
}

- (void) startFallDownItem {
    [self schedule:@selector(scheduleToAddItems) interval:0.5f];
}


- (void) scheduleToAddItems {
 
    int r = arc4random_uniform((unsigned int)self.usedItemList.count);
    
    CCNode *item = [[Item alloc] initItem:[[self.usedItemList objectAtIndex:r] intValue]];
    item.position = ccp(self.boundingBox.size.width / 2, self.boundingBox.size.height + 20);
    //item.scaleX = 2.0;
    //item.scaleY = 2.0;
    
    
    [_physicsNode addChild:item];
    
    CGPoint launchDirection = ccp(0, -1);
    int dif = arc4random_uniform(ITEM_SPEED_DIFF_RANGE);
    CGPoint force = ccpMult(launchDirection, 30 + dif);
    [item.physicsBody applyImpulse:force];
    [_queue enqueue:item];

}

- (void)update:(CCTime)delta
{
    for (id object in _physicsNode.children){
        if ([object isKindOfClass:[Item class]]){
            Item *i = object;
            if ((i.position.x < 0) || (i.position.x > self.boundingBox.size.width) || (i.position.y < 0)){
                [_queue dequeue];
                [[_physicsNode space] addPostStepBlock:^{
                    [self oneObjectRemoved:i];
                } key:i];
            }
            
            Item *firstItem = [_queue peek];
            
            if(firstItem.position.y < _activeZone.boundingBox.size.height) {
                firstItem.spriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"WhichSideAssets/item-1.png"];
            }
        }
    }

    //CCLOG(@"%d", (int)[_queue size]);
}

-(void) touchBegan:(CCTouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:self];
    init_x = touchLocation.x;
    init_y = touchLocation.y;
}


- (void)touchMoved:(CCTouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:self];
    next_x = touchLocation.x;
    next_y = touchLocation.y;
    
    //CCLOG(@"X is %f", next_x);
    //CCLOG(@"Y is %f", next_y);
    
    Item *targetItem = [_queue peek];
    
    double launchAngel, rotationAngel;
    if(touchLocation.x == init_x){
        return;
    }
    if(touchLocation.y > init_y) {
        return;
    }
    if(touchLocation.x < init_x) {
        launchAngel = atan((init_y - touchLocation.y) / (init_x - touchLocation.x));
        rotationAngel = 90 - launchAngel * 180 / M_PI;
    }
    else {
        launchAngel = atan((init_y - touchLocation.y) / (touchLocation.x - init_x));
        rotationAngel = launchAngel * 180 / M_PI - 90;
    }
    
    targetItem.rotation = rotationAngel;
    
    
    CGPoint launchDirection;
    if (touchLocation.x < init_x) {
        launchDirection.x = -cos(launchAngel);
        launchDirection.y = -sin(launchAngel);
    }
    else {
        launchDirection.x = cos(launchAngel);
        launchDirection.y = -sin(launchAngel);
    }
    CGPoint force = ccpMult(launchDirection, SWIPE_SPEED);
    [targetItem.physicsBody applyImpulse:force];
}

-(void) touchEnded:(CCTouch *)touch withEvent:(UIEvent *)event
{
    
}

-(void) touchCancelled:(CCTouch *)touch withEvent:(UIEvent *)event
{
    
}




- (void)oneObjectRemoved:(CCNode *)object {
    [object removeFromParent];
}

@end
