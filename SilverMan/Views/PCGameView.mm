//
//  PCGameView.m
//  SilverMan
//
//  Created by Willy on 28.03.13.
//  Copyright (c) 2013 Willy. All rights reserved.
//

#import "PCGameView.h"

@interface PCGameView()
@property (weak) id<PCGLViewDelegate> delegate;
@end

@implementation PCGameView

#pragma mark Initialize View

-(void) initializeView:(CGSize)size
{
    [self setupLayer];
    [self setupContext];
    [self setupBuffers:size];
}

+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (void)setupLayer {
    _eaglLayer = (CAEAGLLayer*) self.layer;
    _eaglLayer.opaque = YES;
}

- (void)setupContext {
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    _context = [[EAGLContext alloc] initWithAPI:api];
    if (!_context) {
        NSLog(@"Failed to initialize OpenGLES 2.0 context");
        exit(1);
    }
    
    if (![EAGLContext setCurrentContext:_context]) {
        NSLog(@"Failed to set current OpenGL context");
        exit(1);
    }
}

-(void) setupBuffers:(CGSize)_size
{ 
   // NSLog(@"size %@", NSStringFromCGRect(self.frame));
    glGenRenderbuffers(1, &_depthRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, _size.width, _size.height);
    
    
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
    
    GLuint framebuffer;
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderBuffer);
}

#pragma mark -

- (BOOL) paused
{
    return !animating;
}

-(void) setPaused:(BOOL)paused
{
    if (paused) [self stopAnimation];
    else [self startAnimation];
    animating = !paused;
}

- (void)render:(CADisplayLink*)displayLink {
    [self.delegate gameView:self drawInRect:self.frame];
    [self.delegate gameUpdate:displayLink];
    [_context presentRenderbuffer:GL_RENDERBUFFER];
    
    GLenum err = glGetError();
    if (err != GL_NO_ERROR)
    {
        NSLog(@"Render Error 0x%04X", err);
    }
}


- (id)initWithFrame:(CGRect)frame delegate:(id<PCGLViewDelegate>) requestDelegate
{
    self = [super initWithFrame:frame];
    if (self) {
        animating = NO;
        self.delegate = requestDelegate;
        self.contentScaleFactor = [UIScreen mainScreen].scale;
        CGSize size = {frame.size.width*self.contentScaleFactor, frame.size.height*self.contentScaleFactor};
        [self initializeView:size];
        [self startAnimation];
    }
    return self;
}

- (void) startAnimation
{
	if (!animating)
	{
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
        //[_displayLink setFrameInterval:1];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		animating = true;
	}
}

- (void)stopAnimation
{
	if (animating)
	{
        [_displayLink invalidate];
        _displayLink = nil;
		animating = false;
	}
}

@end
