//
//  Piece.h
//  SliderPuzzle
//
//  Created by Richard Adem on 26/04/14.
//  Copyright (c) 2014 Richard Adem. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MoveRule) {
    MOVERULE_HORAZONTAL,
    MOVERULE_VERTICAL,
    MOVERULE_NONE,
    MOVERULE_COUNT
};

@interface Piece : UIView
@property (nonatomic) MoveRule moveRule;
@property (nonatomic, readonly) NSInteger originalIndex;
- (id) initWithImage:(UIImage*) image andOriginalIndex:(NSInteger) originalIndex;

@end
