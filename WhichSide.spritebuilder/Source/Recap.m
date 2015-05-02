//
//  Recap.m
//  WhichSide
//
//  Created by Cyril Lee on 4/28/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Recap.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@implementation Recap {
    CCLabelTTF *_totalScoreTxt;
}

- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
}

- (void)onEnter {
    [super onEnter];
    _totalScoreTxt.string = [NSString stringWithFormat:@"%d", self.totalScore];
}

- (void)reStart {
    [[CCDirector sharedDirector] replaceScene: [CCBReader loadAsScene:@"ChooseType"]];
}


-(void) shareToFacebook {
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    
    // this should link to FB page for your app or AppStore link if published
    content.contentURL = [NSURL URLWithString:@"https://www.facebook.com/makeschool"];
    // URL of image to be displayed alongside post
    content.imageURL = [NSURL URLWithString:@"https://git.makeschool.com/MakeSchool-Tutorials/News/f744d331484d043a373ee2a33d63626c352255d4//663032db-cf16-441b-9103-c518947c70e1/cover_photo.jpeg"];
    // title of post
    content.contentTitle = [NSString stringWithFormat:@"Your score is %@!", _totalScoreTxt.string];
    // description/body of post
    content.contentDescription = @"Check out WhichSide and have fun!";
    
    [FBSDKShareDialog showFromViewController:[CCDirector sharedDirector]
                                 withContent:content
                                    delegate:nil];
}


@end
