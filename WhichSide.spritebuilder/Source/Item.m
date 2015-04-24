//
//  Item.m
//  WhichSide
//
//  Created by Cyril Lee on 4/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Item.h"

static NSString *path = @"WhichSideAssets/item-%d.png";

@implementation Item

- (instancetype) initItem:(int)id {
    self = [super initWithImageNamed:[[NSString alloc] initWithFormat:path, id]];
    return self;
}

- (void) setIsLeft:(BOOL)isLeft {
    self.isLeft = isLeft;
}

@end
