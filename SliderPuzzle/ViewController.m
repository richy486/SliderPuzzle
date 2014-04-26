//
//  ViewController.m
//  SliderPuzzle
//
//  Created by Richard Adem on 26/04/14.
//  Copyright (c) 2014 Richard Adem. All rights reserved.
//

#import "ViewController.h"
#import "Piece.h"

@interface ViewController ()
@property (nonatomic, strong) NSArray *pieces;
@end

@implementation ViewController

NSInteger const PIECES_PER_SIDE = 4;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self setupPieces];
}

- (void) setupPieces {
    UIImage *fullImage = [UIImage imageNamed:@"globe.png"];
    
    CGFloat const pieceSize = fullImage.size.width / PIECES_PER_SIDE;
    NSMutableArray *pieces = [NSMutableArray arrayWithCapacity:PIECES_PER_SIDE*PIECES_PER_SIDE];
    for (NSInteger iX = 0; iX < PIECES_PER_SIDE; ++iX) {
        for (NSInteger iY = 0; iY < PIECES_PER_SIDE; ++iY) {
            
            CGRect pieceRect = CGRectMake(iX * pieceSize * fullImage.scale
                                          , iY * pieceSize * fullImage.scale
                                          , pieceSize * fullImage.scale
                                          , pieceSize * fullImage.scale);
            
            CGImageRef imageRef = CGImageCreateWithImageInRect([fullImage CGImage], pieceRect);
            UIImage *pieceImage = [UIImage imageWithCGImage:imageRef scale:fullImage.scale orientation:fullImage.imageOrientation];
            CGImageRelease(imageRef);
            
            Piece *piece = [[Piece alloc] initWithImage:pieceImage];
            
            piece.center = CGPointMake(CGRectGetMidX(self.view.frame) - ((PIECES_PER_SIDE/2) * pieceSize) + (pieceSize/2) + (iX * pieceSize)
                                       , CGRectGetMidY(self.view.frame) - ((PIECES_PER_SIDE/2) * pieceSize) + (pieceSize/2) + (iY * pieceSize));
            
            [pieces addObject:piece];
        }
    }
    self.pieces = [NSArray arrayWithArray:pieces];
    
    NSInteger i = 0;
    for (Piece *piece in self.pieces) {
        [self.view addSubview:piece];
        ++i;
    }

}

#pragma mark memory man

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
