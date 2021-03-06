//
//  Item.h
//  WhichSide
//
//  Created by Cyril Lee on 4/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface Item : CCSprite

@property (nonatomic, assign) int id;
@property (nonatomic, assign) int score;
@property (nonatomic, assign) int amount;

- (id)initItem:(int)id withPath:(NSString *)path;

- (void)setIsLeft:(BOOL)isLeftSide;

- (BOOL)getIsLeft;

- (void)setForce:(CGPoint)force;

- (CGPoint)getForce;

- (void)setArrow:(CCNode *)a;

- (CCNode *)getArrow;

- (void)setParticleSystem:(CCParticleSystem *)ps;

- (CCParticleSystem *)getParticleSystem;


@end
