//
//  GameConfig.m
//  WhichSide
//
//  Created by Cyril Lee on 5/1/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameConfig.h"

@implementation GameConfig {
    Item *_mainItem;
    int _typeIndex;
    int _levelIndex;
}

- (void)setMainItem:(Item *)i {
    _mainItem = i;
}

- (Item *)getMainItem {
    return _mainItem;
}

- (void)setTypeIndex:(int)t {
    _typeIndex = t;
}

- (int)getTypeIndex {
    return _typeIndex;
}

- (void)setLevelIndex:(int)l {
    _levelIndex = l;
}

- (int)getLevelIndex {
    return _levelIndex;
}

- (int)getTypeAmount {
    switch (_typeIndex) {
        case 0:
            return 10;
        case 1:
            return 26;
        default:
            return 12;
    }
}

- (int)getTypeScore {
    switch (_typeIndex) {
        case 0:
            switch (_levelIndex) {
                case 2:
                    return 10;
                case 3:
                    return 20;
                case 4:
                    return 40;
                default:
                    return 70;
            }
        case 1:
            switch (_levelIndex) {
                case 2:
                    return 30;
                case 3:
                    return 40;
                case 4:
                    return 80;
                default:
                    return 120;
            }
        default:
            switch (_levelIndex) {
                case 2:
                    return 60;
                case 3:
                    return 90;
                case 4:
                    return 120;
                default:
                    return 150;
            }
    }
}

- (int)getTypeTime {
    switch (_typeIndex) {
        case 0:
            switch (_levelIndex) {
                case 2:
                    return 5;
                case 3:
                    return 5;
                case 4:
                    return 7;
                default:
                    return 7;
            }
        case 1:
            switch (_levelIndex) {
                case 2:
                    return 5;
                case 3:
                    return 5;
                case 4:
                    return 7;
                default:
                    return 7;
            }
        default:
            switch (_levelIndex) {
                case 2:
                    return 7;
                case 3:
                    return 7;
                case 4:
                    return 7;
                default:
                    return 7;
            }
    }
}



- (Item *)getItem:(int)id {
    Item *item = nil;
    switch (_typeIndex) {
        case 0:
            item = [[Item alloc] initItem:id withPath:@"NumberAssets/item-%d.png"];
            break;
        case 1:
            item = [[Item alloc] initItem:id withPath:@"LetterAssets/item-%d.png"];
            break;
        default:
            item = [[Item alloc] initItem:id withPath:@"PicAssets/item-%d.png"];
            break;
    }
    return item;
}


@end
