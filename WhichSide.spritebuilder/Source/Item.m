//
//  Item.m
//  WhichSide
//
//  Created by Cyril Lee on 4/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Item.h"

static NSString *path = @"WhichSideAssets/item-%d.png";

@implementation Item {
    BOOL isLeft;
    CGPoint force;
    CCParticleSystem *particleSystem;
    CCNode *arrow;
}

- (instancetype) initItem:(int)id {
    self = [super initWithImageNamed:[[NSString alloc] initWithFormat:path, id]];
    self.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect) {CGPointZero, self.contentSize }cornerRadius:0];
    self.physicsBody.affectedByGravity = YES;
    self.physicsBody.allowsRotation= YES;
    self.physicsBody.density = 1.0;
    self.physicsBody.friction = 0.3;
    self.physicsBody.elasticity = 0.3;
    self.physicsBody.collisionType = @"item";
    self.physicsBody.collisionCategories = @[@"item"];
    self.physicsBody.collisionMask = @[@"leftBound", @"rightBound"];
    self.id = id;
    return self;
}

- (void) setIsLeft:(BOOL)isLeftSide {
    isLeft = isLeftSide;
}

- (BOOL) getIsLeft {
    return isLeft;
}

- (void)setForce:(CGPoint)applyForce {
    force = applyForce;
}

- (CGPoint)getForce {
    return force;
}

- (void)setArrow:(CCNode *)a {
    arrow = a;
}

- (CCNode *)getArrow {
    return arrow;
}

- (void)setParticleSystem:(CCParticleSystem *)ps {
    particleSystem = ps;
}

- (CCParticleSystem *)getParticleSystem {
    return particleSystem;
}


@end
