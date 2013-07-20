//
//  PCGameViewController+GLDraw.m
//  SilverMan
//
//  Created by Willy on 04.02.13.
//  Copyright (c) 2013 Willy. All rights reserved.
//

#import "PCGameViewController+GLDraw.h"


@implementation PCGameViewController (GLDraw)


#pragma mark GLKViewDelegate

- (void) gameView:(UIView *)view drawInRect:(CGRect)rect {
    
    _cLogic->draw();
}

- (void) gameUpdate:(CADisplayLink *)link
{
    _cLogic->update();
}

#pragma mark -

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}


@end
