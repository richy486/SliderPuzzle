//
//  BoardController.m
//  SliderPuzzle
//
//  Created by Richard Adem on 26/04/14.
//  Copyright (c) 2014 Richard Adem. All rights reserved.
//

#import "BoardController.h"
#import "Piece.h"

@interface BoardController() <PieceDelegate>
@property (nonatomic, strong) NSMutableArray *pieces;
@property (nonatomic) CGRect viewRect;
@property (nonatomic) CGFloat pieceSize;
@end

@implementation BoardController

- (id) initWithPieces:(NSArray*) pieces andViewRect:(CGRect) viewRect {
    
    self = [super init];
    if (self){
        self.pieces = [NSMutableArray arrayWithArray:pieces];
        [self.pieces addObject:[NSNull null]];
        
        if ([[self.pieces firstObject] respondsToSelector:@selector(pieceSize)]) {
            self.pieceSize = [[self.pieces firstObject] pieceSize];
        }
        self.viewRect = viewRect;
        
        NSInteger tileCount = [self.pieces count] + 1;
        _piecesPerSide = sqrt(tileCount);
        
        NSInteger index = 0;
        for (Piece *piece in self.pieces) {
            
            if (piece
                && [piece respondsToSelector:@selector(setCenter:)]
                && [piece respondsToSelector:@selector(setGridPosition:)]
                && [piece respondsToSelector:@selector(setDelegate:)]) {
            
                CGPoint position = [self positionForIndex:index];
                piece.center = position;
                piece.gridPosition = position;
                piece.delegate = self;
            }
            ++index;
        }
        [self updateMovablePieces];
    }
    return self;
}

- (void) movePieceTowardsSpace:(Piece*) piece {
    
    
    
    
    
    NSArray *extraPieces = [self allPiecesThatShouldMoveWithSelectedPiece:piece];
    
    // TODO: this should be a chached array for each movement
    NSMutableArray *allPieces = [NSMutableArray arrayWithCapacity:[extraPieces count]];
    NSEnumerator *enumerator = [extraPieces reverseObjectEnumerator];
    for (id element in enumerator) {
        [allPieces addObject:element];
    }
    [allPieces addObject:piece];


    for (Piece *piece in allPieces) {
        
        NSAssert([piece respondsToSelector:@selector(moveToPosition:)], @"all pieces in array should not be Piece objects");
        
        NSInteger indexOfPiece = [self.pieces indexOfObject:piece];
        NSInteger indexOfSpace = [self.pieces indexOfObject:[NSNull null]];
        CGPoint positionOfSpace = [self positionForIndex:indexOfSpace];
        [self.pieces exchangeObjectAtIndex:indexOfPiece withObjectAtIndex:indexOfSpace];
        
        [piece moveToPosition:positionOfSpace];
    }
    
    [self updateMovablePieces];
}

- (void) updateMovablePieces {
    
    NSInteger indexOfSpace = [self.pieces indexOfObject:[NSNull null]];
    
    NSInteger index = 0;
    for (Piece *piece in self.pieces) {
        
        if (index != indexOfSpace && [piece respondsToSelector:@selector(setMoveRule:)]) {
            if (index / _piecesPerSide == indexOfSpace / _piecesPerSide) {
                // is in the same row
                
                if (index < indexOfSpace) {
                    [piece setMoveRule:MOVERULE_LEFTOF_SPACE];
                } else {
                    [piece setMoveRule:MOVERULE_RIGHTOF_SPACE];
                }
            } else if (index % _piecesPerSide == indexOfSpace % _piecesPerSide) {
                // is same column
                
                if (index < indexOfSpace) {
                    [piece setMoveRule:MOVERULE_ABOVE_SPACE];
                } else {
                    [piece setMoveRule:MOVERULE_BELOW_SPACE];
                }
            } else {
                [piece setMoveRule:MOVERULE_NONE];
            }
        }
        
        ++index;
    }
}

#pragma mark Piece Delegate

- (void) pieceDidMoveToEmptySpace:(Piece *)piece {
    
    [self movePieceTowardsSpace:piece];
}

- (NSArray*) allPiecesThatShouldMoveWithSelectedPiece:(Piece*) piece {
    
    NSInteger indexOfPiece = [self.pieces indexOfObject:piece];
    NSInteger indexOfSpace = [self.pieces indexOfObject:[NSNull null]];
    
    NSMutableArray *extraPieces = [NSMutableArray arrayWithCapacity:_piecesPerSide - 1];
    switch (piece.moveRule){
        case MOVERULE_ABOVE_SPACE:
        {
            NSInteger index = indexOfPiece + _piecesPerSide;
            while (index != indexOfSpace) {
                id piece = [self.pieces objectAtIndex:index];
                if (piece && [piece isKindOfClass:[Piece class]]) {
                    [extraPieces addObject:piece];
                }
                
                index += _piecesPerSide;
            }
        }
            break;
        case MOVERULE_BELOW_SPACE:
        {
            NSInteger index = indexOfPiece - _piecesPerSide;
            while (index != indexOfSpace) {
                id piece = [self.pieces objectAtIndex:index];
                if (piece && [piece isKindOfClass:[Piece class]]) {
                    [extraPieces addObject:piece];
                }
                
                index -= _piecesPerSide;
            }
        }
            break;
        case MOVERULE_LEFTOF_SPACE:
        {
            NSInteger index = indexOfPiece + 1;
            while (index != indexOfSpace) {
                id piece = [self.pieces objectAtIndex:index];
                if (piece && [piece isKindOfClass:[Piece class]]) {
                    [extraPieces addObject:piece];
                }
                ++index;
            }
        }
            break;
        case MOVERULE_RIGHTOF_SPACE:
        {
            NSInteger index = indexOfPiece - 1;
            while (index != indexOfSpace) {
                id piece = [self.pieces objectAtIndex:index];
                if (piece && [piece isKindOfClass:[Piece class]]) {
                    [extraPieces addObject:piece];
                }
                --index;
            }
        }
            break;
        case MOVERULE_NONE:
        case MOVERULE_COUNT:
        default:
            break;
    }
    
    return extraPieces;
}

#pragma mark private methods


- (CGPoint) positionForIndex:(NSInteger) index {
    NSInteger x = index % _piecesPerSide;
    NSInteger y = index / _piecesPerSide;
    return [self positionForGridX:x andY:y];
}
- (CGPoint) positionForGridX:(NSInteger) x andY:(NSInteger) y {
    CGPoint position = CGPointMake(CGRectGetMidX(self.viewRect) - ((_piecesPerSide/2) * self.pieceSize) + (self.pieceSize/2) + (x * self.pieceSize)
                                   , CGRectGetMidY(self.viewRect) - ((_piecesPerSide/2) * self.pieceSize) + (self.pieceSize/2) + (y * self.pieceSize));
    return position;
}

@end
