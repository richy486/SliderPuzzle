//
//  ViewController.m
//  SliderPuzzle
//
//  Created by Richard Adem on 26/04/14.
//  Copyright (c) 2014 Richard Adem. All rights reserved.
//

#import "ViewController.h"
#import "Piece.h"
#import "BoardController.h"

@interface ViewController ()
@property (nonatomic, strong) BoardController *boardController;
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
    NSInteger index = 0;
    for (NSInteger iY = 0; iY < PIECES_PER_SIDE; ++iY) {
        for (NSInteger iX = 0; iX < PIECES_PER_SIDE; ++iX) {
            
            if (index < PIECES_PER_SIDE * PIECES_PER_SIDE - 1) {
                CGRect pieceRect = CGRectMake(iX * pieceSize * fullImage.scale
                                              , iY * pieceSize * fullImage.scale
                                              , pieceSize * fullImage.scale
                                              , pieceSize * fullImage.scale);
                
                CGImageRef imageRef = CGImageCreateWithImageInRect([fullImage CGImage], pieceRect);
                UIImage *pieceImage = [UIImage imageWithCGImage:imageRef scale:fullImage.scale orientation:fullImage.imageOrientation];
                CGImageRelease(imageRef);
                
                Piece *piece = [[Piece alloc] initWithImage:pieceImage andOriginalIndex:index];

                [pieces addObject:piece];
                [self.view addSubview:piece];
            }
            
            ++index;
        }
    }
    
    self.boardController = [[BoardController alloc] initWithPieces:pieces andViewRect:self.view.frame];
}

#pragma mark actions

- (IBAction)touchUpIn_btnReset:(id)sender {
    [self.boardController resetPieces];
}

#pragma mark memory man

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
