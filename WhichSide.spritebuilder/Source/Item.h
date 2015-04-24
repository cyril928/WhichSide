//
//  Item.h
//  WhichSide
//
//  Created by Cyril Lee on 4/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface Item : CCSprite

@property (nonatomic, assign) BOOL isLeft;

- (id)initItem:(int)id;

@end
