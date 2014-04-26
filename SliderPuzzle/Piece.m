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
            
            
            UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
            panRecognizer.delegate = self;
            [self addGestureRecognizer:panRecognizer];
        }
    }
    return self;
}

#pragma mark Gestures

- (void) panGesture:(UIPanGestureRecognizer*) gesture {
    
    switch( gesture.state ) {
        case UIGestureRecognizerStatePossible:
            break;
        case UIGestureRecognizerStateBegan:
            [self.superview bringSubviewToFront:self];
            
//            if ([gesture numberOfTouches] == 2) {
//                //                CGPoint pointerPos = [gesture locationInView:[gesture.view superview]];
//                
//                CGPoint touch0 = [gesture locationOfTouch:0 inView:[gesture.view superview]];
//                CGPoint touch1 = [gesture locationOfTouch:1 inView:[gesture.view superview]];
//                
//                self.multiplePanEntities = [NSMutableArray arrayWithArray:[self allEntitiesAtPosition:touch0]];
//                [self.multiplePanEntities addUniqueObjectsFromArray:[NSMutableArray arrayWithArray:[self allEntitiesAtPosition:touch1]]];
//                
//                
//                
//                NSDictionary *userInfo = @{@"positions": @[ @{@"positionX": [NSNumber numberWithFloat:touch0.x], @"positionY": [NSNumber numberWithFloat:touch0.y]}
//                                                            , @{@"positionX": [NSNumber numberWithFloat:touch1.x], @"positionY": [NSNumber numberWithFloat:touch1.y]}]};
//                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DEBUG_DRAW_MARKERS object:nil userInfo:userInfo];
//                
//                
//                
//                
//            }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [gesture translationInView:[gesture.view superview]];
            CGPoint newPosition = CGPointMake(gesture.view.center.x + translation.x, gesture.view.center.y + translation.y);
            gesture.view.center = newPosition;
            
//            if (!self.multiplePanEntities && [gesture numberOfTouches] == 2) {
//                //                CGPoint pointerPos = [gesture locationInView:[gesture.view superview]];
//                
//                CGPoint touch0 = [gesture locationOfTouch:0 inView:[gesture.view superview]];
//                CGPoint touch1 = [gesture locationOfTouch:1 inView:[gesture.view superview]];
//                
//                
//                self.multiplePanEntities = [NSMutableArray arrayWithArray:[self allEntitiesAtPosition:touch0]];
//                [self.multiplePanEntities addUniqueObjectsFromArray:[NSMutableArray arrayWithArray:[self allEntitiesAtPosition:touch1]]];
//                
//                //                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DEBUG_DRAW_MARKERS object:nil userInfo:@{@"positionX": [NSNumber numberWithFloat:pointerPos.x]
//                //                                                                                                                                 , @"positionY": [NSNumber numberWithFloat:pointerPos.y]}];
//                
//                
//                
//                NSDictionary *userInfo = @{@"positions": @[ @{@"positionX": [NSNumber numberWithFloat:touch0.x], @"positionY": [NSNumber numberWithFloat:touch0.y]}
//                                                            , @{@"positionX": [NSNumber numberWithFloat:touch1.x], @"positionY": [NSNumber numberWithFloat:touch1.y]}]};
//                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DEBUG_DRAW_MARKERS object:nil userInfo:userInfo];
//            }
//            if (self.multiplePanEntities && [gesture numberOfTouches] == 1) {
//                self.multiplePanEntities = nil;
//            }
//            
//            for (Entity *entity in self.multiplePanEntities) {
//                if (![entity isEqual:self]) {
//                    entity.center = CGPointMake(entity.center.x + translation.x, entity.center.y + translation.y);
//                }
//            }
            
            [gesture setTranslation:CGPointZero inView:gesture.view];
            
            
        }
            break;
        case UIGestureRecognizerStateEnded:
//            self.multiplePanEntities = nil;
            break;
        case UIGestureRecognizerStateCancelled:
//            self.multiplePanEntities = nil;
            break;
        case UIGestureRecognizerStateFailed:
            break;
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
