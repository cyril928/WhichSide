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
#import "Recap.h"
#import "Queue.h"
#import "CCPhysics+ObjectiveChipmunk.h"

#define M_PI        3.14159265358979323846264338327950288
#define SIDES 2
#define ITEM_SPEED_DIFF_RANGE 20
#define TOTAL_LIVES 10

static const double SWIPE_SPEED = 100;
float init_x, init_y;
float next_x, next_y;
int remaining_Lives;
int score;
CCNode* status;
@implementation GamePlay {
    CCPhysicsNode *_physicsNode;
    CCSprite *_activeZone;
    CCSprite *_leftBound;
    CCSprite *_rightBound;
    Queue *_queue;
    CCLabelTTF *_health;
    CCLabelTTF *_score;
}

- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    _physicsNode.collisionDelegate = self;
    remaining_Lives = TOTAL_LIVES;
    score = 0;
    _health.string = [NSString stringWithFormat:@"%d", remaining_Lives];
    _score.string = [NSString stringWithFormat:@"%d", score];
}

- (void)onEnter {
    [super onEnter];
    _leftBound.physicsBody.collisionType = @"leftBound";
    _rightBound.physicsBody.collisionType = @"rightBound";
    for (id item in self.usedItemList) {
        NSLog(@"%@", item);
    }
    _queue = [[Queue alloc] init];
    [self startFallDownItem];
}

- (void) startFallDownItem {
    [self scheduleOnce:@selector(scheduleToAddItems) delay:0];
    [self schedule:@selector(scheduleToAddItems) interval:0.7f];
}


- (void) scheduleToAddItems {
 
    int r = arc4random_uniform((unsigned int)self.usedItemList.count);
    
    Item *item = [[Item alloc] initItem:[[self.usedItemList objectAtIndex:r] intValue]];
    if(r < [self.usedItemList count] / 2) {
        [item setIsLeft:TRUE];
    }
    else {
        [item setIsLeft:FALSE];
    }
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
                //firstItem.spriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"WhichSideAssets/item-1.png"];
                firstItem.scale = 2.0;
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


- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair item:(CCNode *)nodeA leftBound:(CCNode *)nodeB {

    [[_physicsNode space] addPostStepBlock:^{
        [self itemHitBound:(Item *)nodeA isLeftBound:TRUE];
    } key:nodeA];
    return TRUE;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair item:(CCNode *)nodeA rightBound:(CCNode *)nodeB {
    
    [[_physicsNode space] addPostStepBlock:^{
        [self itemHitBound:(Item *)nodeA isLeftBound:FALSE];
    } key:nodeA];
    return TRUE;
}


- (void)itemHitBound:(Item *)item isLeftBound:(BOOL) isLeft{
    BOOL isLeftSide = [item getIsLeft];
    if((isLeftSide && isLeft) || (!isLeftSide && !isLeft)) {
        status = [CCBReader load:@"Hit"];
        score += 60;
        _score.string = [NSString stringWithFormat:@"%d", score];
    }
    else {
        status = [CCBReader load:@"Miss"];
        remaining_Lives--;
        _health.string = [NSString stringWithFormat:@"%d", remaining_Lives];
        if (remaining_Lives == 0) {
            CCScene *recapScene = [CCBReader loadAsScene:@"Recap"];
            Recap *scene = (Recap *)recapScene.children.firstObject;
            scene.totalScore = score;
            [[CCDirector sharedDirector] replaceScene:recapScene];
        }
    }
    status.position = item.position;
    [self addChild:status];
    [self scheduleOnce:@selector(removeStatus) delay:0.2];
    /*
    // load particle effect
    CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"ItemExplosion"];
    // make the particle effect clean itself up, once it is completed
    explosion.autoRemoveOnFinish = TRUE;
    // place the particle effect on the seals position
    explosion.position = item.position;
    // add the particle effect to the same node the seal is on
    [item.parent addChild:explosion];
    */
    // finally, remove the destroyed seal
    [_queue dequeue];
    [item removeFromParent];
}


- (void) removeStatus {
    [status removeFromParent];
}

- (void)oneObjectRemoved:(CCNode *)object {
    [object removeFromParent];
}

@end
