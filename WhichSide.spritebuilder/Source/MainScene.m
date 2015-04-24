#import "MainScene.h"

@implementation MainScene

- (void)start {
    CCScene *chooseLevelScene = [CCBReader loadAsScene:@"ChooseLevel"];
    [[CCDirector sharedDirector] replaceScene:chooseLevelScene];
}

@end
