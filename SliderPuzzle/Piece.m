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
@end

@implementation Piece

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
            
            _originalIndex = originalIndex;
            
            UILabel *debugNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            debugNumberLabel.textAlignment = NSTextAlignmentCenter;
            debugNumberLabel.backgroundColor = [UIColor whiteColor];
            debugNumberLabel.numberOfLines = 1;
            debugNumberLabel.text = [NSString stringWithFormat:@"%ld", (long)originalIndex];
            [self addSubview:debugNumberLabel];
        }
    }
    return self;
}

#pragma mark Gestures

- (void) panGesture:(UIPanGestureRecognizer*) gesture {
    
    if (self.moveRule != MOVERULE_NONE && self.moveRule != MOVERULE_COUNT) {
        switch( gesture.state ) {
            case UIGestureRecognizerStatePossible:
                break;
            case UIGestureRecognizerStateBegan:
                [self.superview bringSubviewToFront:self];
                
                break;
            case UIGestureRecognizerStateChanged:
            {
                CGPoint translation = [gesture translationInView:[gesture.view superview]];
                CGPoint updatedPosition = gesture.view.center;
                
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
                        updatedPosition.x = MAX(MIN(self.gridPosition.x, updatedPosition.x + translation.x), self.gridPosition.x + self.pieceSize);;
                        break;
                    case MOVERULE_NONE:
                    case MOVERULE_COUNT:
                    default:
                        break;
                }
                gesture.view.center = updatedPosition;
                
                [gesture setTranslation:CGPointZero inView:gesture.view];
            }
                break;
            case UIGestureRecognizerStateEnded:
                break;
            case UIGestureRecognizerStateCancelled:
                break;
            case UIGestureRecognizerStateFailed:
                break;
        }
    }
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
