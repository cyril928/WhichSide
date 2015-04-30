//
//  TimeAnim.m
//  WhichSide
//
//  Created by Cyril Lee on 4/29/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "TimeAnim.h"

@implementation TimeAnim

- (void)didLoadFromCCB
{

}

- (void)startTimeSquare
{
    // the animation manager of each node is stored in the 'animationManager' property
    CCAnimationManager* animationManager = self.animationManager;
    // timelines can be referenced and run by name
    [animationManager runAnimationsForSequenceNamed:@"Time Square"];
}


@end
