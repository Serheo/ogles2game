//
//  PCGameView.h
//  SilverMan
//
//  Created by Willy on 28.03.13.
//  Copyright (c) 2013 Willy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#include "CPPLogic.h"
#import "PCGLViewDelegate.h"

@interface PCGameView : UIView
{
    CAEAGLLayer* _eaglLayer;
    EAGLContext* _context;
    
    BOOL animating;
    CADisplayLink* _displayLink;
    
    GLuint _colorRenderBuffer;
    GLuint _depthRenderBuffer;
}

@property (nonatomic) BOOL paused;
- (void) startAnimation;
- (void) stopAnimation;
- (id) initWithFrame:(CGRect)frame delegate:(id<PCGLViewDelegate>) requestDelegate;
@end
