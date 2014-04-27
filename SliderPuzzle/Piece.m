//
//  Piece.m
//  SliderPuzzle
//
//  Created by Richard Adem on 26/04/14.
//  Copyright (c) 2014 Richard Adem. All rights reserved.
//

#import "Piece.h"

@interface Piece() <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIImageView *mainImage;
@property (nonatomic) CGFloat pieceSize;
@property (nonatomic, weak) UILabel *debugNumberLabel;
@end

@implementation Piece

CGFloat MOVE_ANIMATION_TIME = 0.2;

static BOOL _isPieceAlreadyMoving = NO;


- (id) initWithImage:(UIImage*) image andOriginalIndex:(NSInteger) originalIndex {
    
    
    CGRect frame;
    if (image) {
        frame = CGRectMake(0, 0, image.size.width, image.size.height);
    } else {
        frame = CGRectZero;
    }
    
    self = [super initWithFrame:frame];
    if (self) {
        if (image) {
            self.mainImage = [[UIImageView alloc] initWithImage:image];
            self.mainImage.frame = self.bounds;
            
            [self addSubview:self.mainImage];
            
            NSAssert(image.size.height == image.size.width, @"image width and height dont match");
            self.pieceSize = image.size.height;
            self.moveRule = MOVERULE_NONE;
            
            UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
            panRecognizer.delegate = self;
            [self addGestureRecognizer:panRecognizer];
            
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
            tapRecognizer.delegate = self;
            [self addGestureRecognizer:tapRecognizer];
            
            _originalIndex = originalIndex;
            
            UILabel *debugNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.pieceSize - 10, 30)];
            self.debugNumberLabel = debugNumberLabel;
            self.debugNumberLabel.textAlignment = NSTextAlignmentCenter;
            self.debugNumberLabel.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.75];
            self.debugNumberLabel.numberOfLines = 1;
            self.debugNumberLabel.text = [NSString stringWithFormat:@"%ld", (long)originalIndex];
            [self addSubview:self.debugNumberLabel];
        }
    }
    return self;
}

#pragma movement

- (void) animateBackToGridPosition {
    [UIView animateWithDuration:MOVE_ANIMATION_TIME
                     animations:^{
                         self.center = self.gridPosition;
                     }
                     completion:^(BOOL finished) {
                         _isPieceAlreadyMoving = NO;
                     }];
}

- (void) animateToPosition:(CGPoint) position {
    
    [UIView animateWithDuration:MOVE_ANIMATION_TIME
                     animations:^{
                         
                         self.center = position;
                     }
                     completion:^(BOOL finished) {
                         self.gridPosition = position;
                         _isPieceAlreadyMoving = NO;
                     }];
}

- (void) moveBy:(CGPoint) translation {
    CGPoint updatedPosition = self.center;
    
    switch (self.moveRule) {
        case MOVERULE_ABOVE_SPACE:
            updatedPosition.y = MIN(MAX(self.gridPosition.y, updatedPosition.y + translation.y), self.gridPosition.y + self.pieceSize);
            break;
        case MOVERULE_BELOW_SPACE:
            updatedPosition.y = MAX(MIN(self.gridPosition.y, updatedPosition.y + translation.y), self.gridPosition.y - self.pieceSize);
            break;
        case MOVERULE_LEFTOF_SPACE:
            updatedPosition.x = MIN(MAX(self.gridPosition.x, updatedPosition.x + translation.x), self.gridPosition.x + self.pieceSize);
            break;
        case MOVERULE_RIGHTOF_SPACE:
            updatedPosition.x = MAX(MIN(self.gridPosition.x, updatedPosition.x + translation.x), self.gridPosition.x - self.pieceSize);
            break;
        case MOVERULE_NONE:
        case MOVERULE_COUNT:
        default:
            break;
    }
    self.center = updatedPosition;
}

#pragma move rules

- (void) setMoveRule:(MoveRule)moveRule {
    _moveRule = moveRule;
    
    NSString *moveRuleString = nil;
    switch (self.moveRule) {
        case MOVERULE_ABOVE_SPACE:
            moveRuleString = @"A";
            break;
        case MOVERULE_BELOW_SPACE:
            moveRuleString = @"B";
            break;
        case MOVERULE_LEFTOF_SPACE:
            moveRuleString = @"L";
            break;
        case MOVERULE_RIGHTOF_SPACE:
            moveRuleString = @"R";
            break;
        case MOVERULE_NONE:
            moveRuleString = @"";
            break;
        case MOVERULE_COUNT:
            moveRuleString = @"!";
            break;
        default:
            break;
    }
    self.debugNumberLabel.text = [NSString stringWithFormat:@"%ld %@", (long)_originalIndex, moveRuleString];
}

#pragma mark Gestures

- (void) panGesture:(UIPanGestureRecognizer*) gesture {
    
    if (self.moveRule != MOVERULE_NONE && self.moveRule != MOVERULE_COUNT) {
        switch (gesture.state) {
            case UIGestureRecognizerStatePossible:
                break;
            case UIGestureRecognizerStateBegan:
                _isPieceAlreadyMoving = YES;
                [self.superview bringSubviewToFront:self];
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(pieceDidStartMoving:)]) {
                    [self.delegate pieceDidStartMoving:self];
                }
                
                break;
            case UIGestureRecognizerStateChanged:
            {
                CGPoint translation = [gesture translationInView:[gesture.view superview]];
//                CGPoint updatedPosition = gesture.view.center;
//                
//                switch (self.moveRule) {
//                    case MOVERULE_ABOVE_SPACE:
//                        updatedPosition.y = MIN(MAX(self.gridPosition.y, updatedPosition.y + translation.y), self.gridPosition.y + self.pieceSize);
//                        break;
//                    case MOVERULE_BELOW_SPACE:
//                        updatedPosition.y = MAX(MIN(self.gridPosition.y, updatedPosition.y + translation.y), self.gridPosition.y - self.pieceSize);
//                        break;
//                    case MOVERULE_LEFTOF_SPACE:
//                        updatedPosition.x = MIN(MAX(self.gridPosition.x, updatedPosition.x + translation.x), self.gridPosition.x + self.pieceSize);
//                        break;
//                    case MOVERULE_RIGHTOF_SPACE:
//                        updatedPosition.x = MAX(MIN(self.gridPosition.x, updatedPosition.x + translation.x), self.gridPosition.x - self.pieceSize);
//                        break;
//                    case MOVERULE_NONE:
//                    case MOVERULE_COUNT:
//                    default:
//                        break;
//                }
//                gesture.view.center = updatedPosition;
                
                
//                if ([gesture.view respondsToSelector:@selector(moveBy:)]) {
//                    [(id)(gesture.view) moveBy:translation];
//                }
                
                [gesture setTranslation:CGPointZero inView:gesture.view];
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(piece:didMoveBy:)]) {
                    [self.delegate piece:self didMoveBy:translation];
                }
            }
                break;
            case UIGestureRecognizerStateEnded:
            {
                BOOL hasTakenEmptyPosition = NO;
                switch (self.moveRule) {
                    case MOVERULE_ABOVE_SPACE:
                        hasTakenEmptyPosition = gesture.view.center.y - self.gridPosition.y > self.pieceSize/2;
                        break;
                    case MOVERULE_BELOW_SPACE:
                        hasTakenEmptyPosition = self.gridPosition.y - gesture.view.center.y > self.pieceSize/2;
                        break;
                    case MOVERULE_LEFTOF_SPACE:
                        hasTakenEmptyPosition = gesture.view.center.x - self.gridPosition.x > self.pieceSize/2;
                        break;
                    case MOVERULE_RIGHTOF_SPACE:
                        hasTakenEmptyPosition = self.gridPosition.x - gesture.view.center.x > self.pieceSize/2;
                        break;
                    case MOVERULE_NONE:
                    case MOVERULE_COUNT:
                    default:
                        break;
                }
                
                if (hasTakenEmptyPosition) {
                    if (self.delegate && [self.delegate respondsToSelector:@selector(pieceDidFinishMovingToEmptySpace:)]) {
                        [self.delegate pieceDidFinishMovingToEmptySpace:self];
                    }
                } else {
                    if (self.delegate && [self.delegate respondsToSelector:@selector(pieceDidCancelMovement:)]) {
                        [self.delegate pieceDidCancelMovement:self];
                    }
                }
            }
                break;
            case UIGestureRecognizerStateCancelled:
                if (self.delegate && [self.delegate respondsToSelector:@selector(pieceDidCancelMovement:)]) {
                    [self.delegate pieceDidCancelMovement:self];
                }
                break;
            case UIGestureRecognizerStateFailed:
                if (self.delegate && [self.delegate respondsToSelector:@selector(pieceDidCancelMovement:)]) {
                    [self.delegate pieceDidCancelMovement:self];
                }
                break;
        }
    }
}

- (void) tapGesture:(UIPanGestureRecognizer*) gesture {
    if (self.moveRule != MOVERULE_NONE && self.moveRule != MOVERULE_COUNT) {
        switch (gesture.state) {
            case UIGestureRecognizerStatePossible:
                break;
            case UIGestureRecognizerStateBegan:
                break;
            case UIGestureRecognizerStateChanged:
                break;
            case UIGestureRecognizerStateEnded:
                if (self.delegate && [self.delegate respondsToSelector:@selector(pieceDidFinishMovingToEmptySpace:)]) {
                    [self.delegate pieceDidFinishMovingToEmptySpace:self];
                }
                break;
            case UIGestureRecognizerStateCancelled:
                break;
            case UIGestureRecognizerStateFailed:
                break;
        }
    }
}

#pragma mark gesture delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (_isPieceAlreadyMoving) {
        return NO;
    }
    
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
