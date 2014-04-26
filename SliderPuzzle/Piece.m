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

@end

@implementation Piece

- (id) initWithImage:(UIImage*) image {
    
    
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
            
            self.moveable = YES;
            
            UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
            panRecognizer.delegate = self;
            [self addGestureRecognizer:panRecognizer];
        }
    }
    return self;
}

#pragma mark Gestures

- (void) panGesture:(UIPanGestureRecognizer*) gesture {
    
    if (self.moveable) {
        switch( gesture.state ) {
            case UIGestureRecognizerStatePossible:
                break;
            case UIGestureRecognizerStateBegan:
                [self.superview bringSubviewToFront:self];
                
                break;
            case UIGestureRecognizerStateChanged:
            {
                CGPoint translation = [gesture translationInView:[gesture.view superview]];
                CGPoint newPosition = CGPointMake(gesture.view.center.x + translation.x, gesture.view.center.y + translation.y);
                gesture.view.center = newPosition;
                
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
