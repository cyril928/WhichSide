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
#define TOTAL_LIVES 7

static const double SWIPE_SPEED = 200;
float init_x, init_y;
float next_x, next_y;
int remaining_Lives;
int score;
CCNode *status;
CCNode *brokenHeart;
NSMutableArray *intervalList;
NSMutableArray *repeatList;
int circularIndex = 0;

@implementation GamePlay {
    CCPhysicsNode *_physicsNode;
    CCSprite *_activeZone;
    CCSprite *_leftBound;
    CCSprite *_rightBound;
    Queue *_queue;
    CCSprite *_heart;
    CCLabelTTF *_health;
    CCLabelTTF *_score;
    CCSprite *_scoreBar;
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
    intervalList = [NSMutableArray array];
    [intervalList addObject:@(1.0f)];
    [intervalList addObject:@(0.75f)];
    [intervalList addObject:@(0.5f)];
    repeatList = [NSMutableArray array];
    [repeatList addObject:@(5)];
    [repeatList addObject:@(7)];
    [repeatList addObject:@(11)];
    CCLOG(@"interval is %f, repeat is %d", [[intervalList objectAtIndex:0] floatValue], [[repeatList objectAtIndex:0] intValue]);
    CCLOG(@"interval is %f, repeat is %d", [[intervalList objectAtIndex:1] floatValue], [[repeatList objectAtIndex:1] intValue]);
    CCLOG(@"interval is %f, repeat is %d", [[intervalList objectAtIndex:2] floatValue], [[repeatList objectAtIndex:2] intValue]);
    [self startFallDownItem];
}

- (void) startFallDownItem {
    [self schedule:@selector(scheduleToAddItems) interval:[[intervalList objectAtIndex:circularIndex] floatValue] repeat:[[repeatList objectAtIndex:circularIndex] intValue] delay:0];
    circularIndex = (circularIndex + 1) % [intervalList count];
    [self schedule:@selector(startRealGame) interval:7.0f];
}

- (void) startRealGame {
    [self schedule:@selector(scheduleToAddItems) interval:[[intervalList objectAtIndex:circularIndex] floatValue] repeat:[[repeatList objectAtIndex:circularIndex] intValue] delay:0];
    circularIndex = (circularIndex + 1) % [intervalList count];
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
    item.position = ccp(self.boundingBox.size.width / 2, self.boundingBox.size.height - _scoreBar.boundingBox.size.height / 2);
    //item.scaleX = 2.0;
    //item.scaleY = 2.0;
    
    
    [_physicsNode addChild:item];
    
    CGPoint launchDirection = ccp(0, -1);
    int dif = arc4random_uniform(ITEM_SPEED_DIFF_RANGE);
    CGPoint force = ccpMult(launchDirection, 30 + dif);
    //[item setForce:force];
    [item.physicsBody applyForce:force];
    [_queue enqueue:item];

}

- (void)update:(CCTime)delta
{
    for (id object in _physicsNode.children){
        if ([object isKindOfClass:[Item class]]){
            Item *i = object;
            if ((i.position.x < 0) || (i.position.x > self.boundingBox.size.width) || (i.position.y - i.contentSize.height / 2 < 0)){
                [_queue dequeue];
                
                /*
                CCNode *a = [i getArrow];
                [[_physicsNode space] addPostStepBlock:^{
                    [self oneObjectRemoved:a];
                } key:a];
                */
                /*
                CCParticleSystem *ps = [i getParticleSystem];
                [[_physicsNode space] addPostStepBlock:^{
                    [self oneObjectRemoved:ps];
                } key:ps];
                */
                
                [[_physicsNode space] addPostStepBlock:^{
                    if(i.position.y - i.contentSize.height / 2 < 0) {
                        [self call:i status:FALSE bottom:TRUE];
                    }
                    [self oneObjectRemoved:i];
                } key:i];
            }
        }
    }
    Item *firstItem = [_queue peek];
    
    if(firstItem.position.y < _activeZone.boundingBox.size.height) {
        //firstItem.spriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"WhichSideAssets/item-1.png"];
        //firstItem.scale = 2.0;
        /*
        if([firstItem getArrow] == nil) {
         
            CCParticleSystem *ps = (CCParticleSystem *)[CCBReader load:@"ItemShow"];
            ps.position = firstItem.position;
            ps.autoRemoveOnFinish = FALSE;
            [firstItem.parent addChild:ps];
            [ps.physicsBody applyImpulse:[firstItem getForce]];
            [firstItem setParticleSystem:ps];
         
            
         
            CCNode *arrow = (CCNode *)[CCBReader load:@"Arrow"];
            arrow.physicsBody.body.mass = 1.0f;
            arrow.position = ccp(firstItem.position.x, firstItem.position.y + firstItem.contentSize.height / 2 + arrow.contentSize.height / 2 + 5);
            [firstItem.parent addChild:arrow];
            [arrow.physicsBody applyImpulse:[firstItem getForce]];
            [firstItem setArrow:arrow];
         
        }*/
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
        [self call:item status:TRUE bottom:FALSE];
    }
    else {
        [self call:item status:FALSE bottom:FALSE];
    }
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
    
    /*
    CCNode *a = [item getArrow];
    [a removeFromParent];
    */
     /*
    CCParticleSystem *ps = [item getParticleSystem];
    [ps removeFromParent];
     */
    [item removeFromParent];

}

- (void) call:(Item *)item status:(BOOL)hit bottom:(BOOL)bottom {
    if(hit) {
        status = [CCBReader load:@"Hit"];
        score += 60;
        _score.string = [NSString stringWithFormat:@"%d", score];
        status.position = item.position;
        [self addChild:status];
        [self scheduleOnce:@selector(removeHitStatus) delay:0.2];
    }
    else {
        brokenHeart = [CCBReader load:@"HeartBroken"];
        brokenHeart.position = ccp(_heart.position.x, _heart.position.y - _heart.boundingBox.size.height / 2 - 10);
        [self scheduleOnce:@selector(removeMissHeartBroken) delay:0.3];
        [self addChild:brokenHeart];
        
        status = [CCBReader load:@"Miss"];
        remaining_Lives--;
        _health.string = [NSString stringWithFormat:@"%d", remaining_Lives];
        if(bottom) {
            status.position = ccp(item.position.x, item.position.y + item.boundingBox.size.height / 2 + 10);
        }
        else {
             status.position = item.position;
        }
        [self addChild:status];
        [self scheduleOnce:@selector(removeMissStatus) delay:0.2];
        if (remaining_Lives == 0) {
            CCScene *recapScene = [CCBReader loadAsScene:@"Recap"];
            Recap *scene = (Recap *)recapScene.children.firstObject;
            scene.totalScore = score;
            [[CCDirector sharedDirector] replaceScene:recapScene];
        }
    }
}


- (void) removeHitStatus {
    CCParticleSystem *ps = (CCParticleSystem *)[CCBReader load:@"HitShow"];
    ps.autoRemoveOnFinish = TRUE;
    ps.position = status.position;
    [status.parent addChild:ps];
    [status removeFromParent];
}

- (void) removeMissStatus {
    CCParticleSystem *ps = (CCParticleSystem *)[CCBReader load:@"MissShow"];
    ps.autoRemoveOnFinish = TRUE;
    ps.position = status.position;
    [status.parent addChild:ps];
    [status removeFromParent];
}

- (void) removeMissHeartBroken {
    CCParticleSystem *ps = (CCParticleSystem *)[CCBReader load:@"MissShow"];
    ps.autoRemoveOnFinish = TRUE;
    ps.position = brokenHeart.position;
    [brokenHeart.parent addChild:ps];
    [brokenHeart removeFromParent];
}

- (void)oneObjectRemoved:(CCNode *)object {
    [object removeFromParent];
}

@end
