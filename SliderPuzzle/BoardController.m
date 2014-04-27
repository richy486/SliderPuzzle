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

@property (nonatomic, strong) NSArray *piecesToMove;
@end

@implementation BoardController

NSInteger const SHUFFLE_MOVES = 500;

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

    if (!self.piecesToMove || [self.piecesToMove count] == 0) {
        self.piecesToMove = [self allPiecesThatShouldMoveWithAndIncludingPiece:piece];
    }

    for (Piece *piece in self.piecesToMove) {
        
        NSAssert([piece respondsToSelector:@selector(animateToPosition:)], @"all pieces in array should not be Piece objects");
        
        NSInteger indexOfPiece = [self.pieces indexOfObject:piece];
        NSInteger indexOfSpace = [self.pieces indexOfObject:[NSNull null]];
        CGPoint positionOfSpace = [self positionForIndex:indexOfSpace];
        [self.pieces exchangeObjectAtIndex:indexOfPiece withObjectAtIndex:indexOfSpace];
        
        [piece animateToPosition:positionOfSpace];
    }
    
    [self updateMovablePieces];
}

- (void) shufflePieces {
    
    for (NSInteger i = 0; i < SHUFFLE_MOVES; ++i) {
        
        // adjacent positions count
        BOOL sides[4] = {NO, NO, NO, NO};
        
        const NSInteger leftIndex = 0;
        const NSInteger rightIndex = 1;
        const NSInteger aboveIndex = 2;
        const NSInteger belowIndex = 3;
        
        NSInteger sidesAvailable = 0;
        NSInteger indexOfSpace = [self.pieces indexOfObject:[NSNull null]];
        if ((indexOfSpace - 1) / _piecesPerSide == indexOfSpace / _piecesPerSide && indexOfSpace - 1 >= 0) {
            sides[leftIndex] = YES;
            sidesAvailable++;
        }
        if ((indexOfSpace + 1) / _piecesPerSide == indexOfSpace / _piecesPerSide && indexOfSpace + 1 < _piecesPerSide * _piecesPerSide) {
            sides[rightIndex] = YES;
            sidesAvailable++;
        }
        if (indexOfSpace - _piecesPerSide >= 0) {
            sides[aboveIndex] = YES;
            sidesAvailable++;
        }
        if (indexOfSpace + _piecesPerSide < _piecesPerSide * _piecesPerSide) {
            sides[belowIndex] = YES;
            sidesAvailable++;
        }
        
        NSAssert(sidesAvailable > 0, @"no available sides");
        
        // pick position from available
        NSInteger randSide = arc4random()%sidesAvailable;
        
        NSInteger sidesSteppedThrough = -1;
        NSInteger moveToSideIndex = -1;
        for (NSInteger j = 0; j < 4; ++j) {
            
            if (sides[j]) {
                ++sidesSteppedThrough;
                if (sidesSteppedThrough == randSide) {
                    moveToSideIndex = j;
                }
            }
        }
        
        NSAssert(moveToSideIndex >= 0, @"could not find an available side");
        
        // move piece into space
        NSInteger pieceIndex = -1;
        switch (moveToSideIndex) {
            case leftIndex:
                pieceIndex = indexOfSpace - 1;
                break;
            case rightIndex:
                pieceIndex = indexOfSpace + 1;
                break;
            case aboveIndex:
                pieceIndex = indexOfSpace - _piecesPerSide;
                break;
            case belowIndex:
                pieceIndex = indexOfSpace + _piecesPerSide;
                break;
            default:
                break;
        }
        
        Piece *pieceToMove = [self.pieces objectAtIndex:pieceIndex];
        NSAssert([pieceToMove isKindOfClass:[Piece class]], @"tried to move non piece");
        
        [self.pieces exchangeObjectAtIndex:pieceIndex withObjectAtIndex:indexOfSpace];
    }
    
    [self updateMovablePieces];
    
    NSInteger index = 0;
    for (Piece *piece in self.pieces) {
        
        if ([piece respondsToSelector:@selector(animateToPosition:)]) {
            CGPoint position = [self positionForIndex:index];
            [piece animateToPosition:position];
        }
        ++index;
    }
}

- (void) resetPieces {
    
    for (Piece *piece in self.pieces) {
        if ([piece respondsToSelector:@selector(animateToPosition:)]) {
            
            CGPoint position = [self positionForIndex:piece.originalIndex];
            [piece animateToPosition:position];
        }
    }
    
    NSArray *sortedPieces = [self.pieces sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        
        if (![a respondsToSelector:@selector(originalIndex)]) {
            return NSOrderedDescending;
        } else if (![b respondsToSelector:@selector(originalIndex)]) {
            return NSOrderedAscending;
        } else if ([a originalIndex] < [b originalIndex]) {
            return NSOrderedAscending;
        } else if ([a originalIndex] > [b originalIndex]) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    self.pieces = [NSMutableArray arrayWithArray:sortedPieces];
    
    [self updateMovablePieces];
}

#pragma mark Piece Delegate

- (void) pieceDidStartMoving:(Piece *)piece {
    
    self.piecesToMove = [self allPiecesThatShouldMoveWithAndIncludingPiece:piece];
}

- (void) piece:(Piece *)piece didMoveBy:(CGPoint)translation {
    
    for (Piece *piece in self.piecesToMove) {
        if (piece && [piece respondsToSelector:@selector(moveBy:)]) {
            [piece moveBy:translation];
        }
    }
}

- (void) pieceDidFinishMovingToEmptySpace:(Piece *)piece {
    
    [self movePieceTowardsSpace:piece];
    self.piecesToMove = nil;
}

- (void) pieceDidCancelMovement:(Piece*) piece {
    for (Piece *piece in self.piecesToMove) {
        if (piece && [piece respondsToSelector:@selector(animateBackToGridPosition)]) {
            [piece animateBackToGridPosition];
        }
    }
}

#pragma mark private methods

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

- (NSArray*) allPiecesThatShouldMoveWithAndIncludingPiece:(Piece *)piece {
    
    NSInteger indexOfPiece = [self.pieces indexOfObject:piece];
    NSInteger indexOfSpace = [self.pieces indexOfObject:[NSNull null]];
    
    NSMutableArray *extraPieces = [NSMutableArray arrayWithCapacity:_piecesPerSide - 1];
    
    NSInteger offset = 0;
    
    switch (piece.moveRule){
        case MOVERULE_ABOVE_SPACE:
            offset = -_piecesPerSide;
            break;
        case MOVERULE_BELOW_SPACE:
            offset = +_piecesPerSide;
            break;
        case MOVERULE_LEFTOF_SPACE:
            offset = -1;
            break;
        case MOVERULE_RIGHTOF_SPACE:
            offset = +1;
            break;
        case MOVERULE_NONE:
        case MOVERULE_COUNT:
        default:
            break;
    }
    
    if (offset != 0) {
        NSInteger index = indexOfSpace + offset;
        while (index != indexOfPiece + offset && index >= 0 && index < _piecesPerSide * _piecesPerSide) {
            id piece = [self.pieces objectAtIndex:index];
            if (piece && [piece isKindOfClass:[Piece class]]) {
                [extraPieces addObject:piece];
            }
            index += offset;
        }
    }
    
    return extraPieces;
}

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
