//
//  Piece.h
//  SliderPuzzle
//
//  Created by Richard Adem on 26/04/14.
//  Copyright (c) 2014 Richard Adem. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MoveRule) {
    MOVERULE_ABOVE_SPACE,
    MOVERULE_BELOW_SPACE,
    MOVERULE_LEFTOF_SPACE,
    MOVERULE_RIGHTOF_SPACE,
    MOVERULE_NONE,
    MOVERULE_COUNT
};

@interface Piece : UIView
@property (nonatomic) MoveRule moveRule;
@property (nonatomic, readonly) NSInteger originalIndex;
@property (nonatomic) CGPoint gridPosition;
- (id) initWithImage:(UIImage*) image andOriginalIndex:(NSInteger) originalIndex;

@end
