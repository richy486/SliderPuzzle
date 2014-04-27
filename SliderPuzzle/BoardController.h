//
//  BoardController.h
//  SliderPuzzle
//
//  Created by Richard Adem on 26/04/14.
//  Copyright (c) 2014 Richard Adem. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Piece;

@interface BoardController : NSObject
@property (nonatomic, readonly) NSInteger piecesPerSide;
- (id) initWithPieces:(NSArray*) pieces andViewRect:(CGRect) viewRect;
- (void) movePieceTowardsSpace:(Piece*) piece;
- (void) shufflePieces;
- (void) resetPieces;
@end
