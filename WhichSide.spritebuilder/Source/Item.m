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
    self.id = id;
    return self;
}

- (void) setIsLeft:(BOOL)isLeftSide {
    isLeft = isLeftSide;
}

- (BOOL) getIsLeft {
    return isLeft;
}

@end
