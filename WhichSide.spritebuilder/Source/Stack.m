//
//  Stack.m
//  WhichSide
//
//  Created by Cyril Lee on 4/29/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Stack.h"

@implementation Stack

-(id)init
{
    if ( (self = [super init]) ) {
        array = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(id)pop
{
    id object = [self peek];
    [array removeLastObject];
    return object;
}

-(void)push:(id)element
{
    [array addObject:element];
}

-(void)pushElementsFromArray:(NSArray*)arr
{
    [array addObjectsFromArray:arr];
}

-(id)peek
{
    return [array lastObject];
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

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len;
{
    return [array countByEnumeratingWithState:state objects:buffer count:len];
}


@end
