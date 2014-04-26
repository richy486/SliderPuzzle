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
        
        if (index != indexOfSpace && [piece respondsToSelector:@selector(setMoveable:)]) {
            if ((index == indexOfSpace - _piecesPerSide) // above
                || (index == indexOfSpace + _piecesPerSide) // below
                || (index == indexOfSpace - 1 && (indexOfSpace%_piecesPerSide) != 0) // left
                || (index == indexOfSpace - 1 && (index%_piecesPerSide) != 0)) { // right
                
                [piece setMoveable:YES];
            } else {
                [piece setMoveable:NO];
            }
        }
        
        ++index;
    }
}

@end
