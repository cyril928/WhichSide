//
//  Queue.m
//  WhichSide
//
//  Created by Cyril Lee on 4/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Queue.h"

@implementation Queue

-(id)init
{
    if ( (self = [super init]) ) {
        array = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(id)dequeue
{
    if ([array count] > 0) {
        id object = [self peek];
        [array removeObjectAtIndex:0];
        return object;
    }
    
    return nil;
}

-(void)enqueue:(id)element
{
    [array addObject:element];
}

-(void)enqueueElementsFromArray:(NSArray*)arr
{
    [array addObjectsFromArray:arr];
}

-(void)enqueueElementsFromQueue:(Queue*)queue
{
    while (![queue isEmpty]) {
        [self enqueue:[queue dequeue]];
    }
}

-(id)peek
{
    if ([array count] > 0)
        return [array objectAtIndex:0];
    
    return nil;
}

-(NSInteger)size
{
    return [array count];
}

-(BOOL)isEmpty
{
    return [array count] == 0;
}

-(void)clear
{
    [array removeAllObjects];
}

@end
