#import "MainScene.h"

@implementation MainScene

- (void)start {
    CCScene *chooseTypeScene = [CCBReader loadAsScene:@"ChooseType"];
    [[CCDirector sharedDirector] replaceScene:chooseTypeScene];
}

@end
