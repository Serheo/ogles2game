//
//  PCGLViewDelegate.h
//  SilverMan
//
//  Created by Willy on 30.03.13.
//  Copyright (c) 2013 Willy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PCGLViewDelegate

@required
- (void) gameView:(UIView *)view drawInRect:(CGRect)rect;
- (void) gameUpdate:(CADisplayLink *)link;

@end
