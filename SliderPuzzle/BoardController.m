//
//  BoardController.m
//  SliderPuzzle
//
//  Created by Richard Adem on 26/04/14.
//  Copyright (c) 2014 Richard Adem. All rights reserved.
//

#import "BoardController.h"
#import "Piece.h"

@interface BoardController()
//@property (nonatomic, strong) NSArray *pieces;
@property (nonatomic, strong) NSMutableArray *pieces;
@end

@implementation BoardController

- (id) initWithPieces:(NSArray*) pieces {
    
    self = [super init];
    if (self){
        self.pieces = [NSMutableArray arrayWithArray:pieces];
        [self.pieces addObject:[NSNull null]];

        NSInteger tileCount = [self.pieces count] + 1;
        _piecesPerSide = sqrt(tileCount);
        
        
        [self updateMovablePieces];
    }
    return self;
}

- (void) movePieceIntoSpace:(Piece*) piece {
    
    NSInteger indexOfPiece = [self.pieces indexOfObject:piece];
    NSInteger indexOfSpace = [self.pieces indexOfObject:[NSNull null]];
    
    [self.pieces exchangeObjectAtIndex:indexOfPiece withObjectAtIndex:indexOfSpace];
    
    [self updateMovablePieces];
}

- (void) updateMovablePieces {
    
    NSInteger indexOfSpace = [self.pieces indexOfObject:[NSNull null]];
    
    NSInteger index = 0;
    for (Piece *piece in self.pieces) {
        
        if (index != indexOfSpace && [piece respondsToSelector:@selector(setMoveRule:)]) {
            if (index == indexOfSpace - _piecesPerSide) {
                [piece setMoveRule:MOVERULE_ABOVE_SPACE];
            } else if (index == indexOfSpace + _piecesPerSide){
                [piece setMoveRule:MOVERULE_BELOW_SPACE];
            } else if (index == indexOfSpace - 1 && (indexOfSpace%_piecesPerSide) != 0) {
                [piece setMoveRule:MOVERULE_LEFTOF_SPACE];
            } else if (index == indexOfSpace - 1 && (index%_piecesPerSide) != 0) {
                [piece setMoveRule:MOVERULE_RIGHTOF_SPACE];
            } else {
                [piece setMoveRule:MOVERULE_NONE];
            }
        }
        
        ++index;
    }
}

@end
