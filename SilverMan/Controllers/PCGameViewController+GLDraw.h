//
//  PCGameViewController+GLDraw.h
//  SilverMan
//
//  Created by Willy on 04.02.13.
//  Copyright (c) 2013 Willy. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PCGameViewController.h"

@interface PCGameViewController (GLDraw)

- (void) gameUpdate:(CADisplayLink *)link;
- (void) gameView:(UIView *)view drawInRect:(CGRect)rect;

@end