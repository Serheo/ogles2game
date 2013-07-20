//
//  PCGameViewController+Controls.m
//  SilverMan
//
//  Created by Willy on 02.02.13.
//  Copyright (c) 2013 Willy. All rights reserved.
//

#import "PCGameViewController+Controls.h"

@implementation PCGameViewController (Controls)

-(void) initializeControls
{
    [arrowUp setBackgroundImage:[UIImage imageNamed:@"arrowUp"] forState:UIControlStateNormal];
    [arrowDown setBackgroundImage:[UIImage imageNamed:@"arrowDown"] forState:UIControlStateNormal];
    [arrowLeft setBackgroundImage:[UIImage imageNamed:@"arrowLeft"] forState:UIControlStateNormal];
    [arrowRight setBackgroundImage:[UIImage imageNamed:@"arrowRight"] forState:UIControlStateNormal];
    
    [self setPlayPause:NO];
    [stopButton setBackgroundImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    [stopButton setBackgroundImage:[UIImage imageNamed:@"stopHighlighted"] forState:UIControlStateHighlighted];
    
    [self setSoundState];
    [self setMusicState];
    
    UISwipeGestureRecognizer *swipeRecognizer;
    for (NSNumber *item in @[ @(UISwipeGestureRecognizerDirectionLeft),  @(UISwipeGestureRecognizerDirectionDown),
         @(UISwipeGestureRecognizerDirectionRight), @(UISwipeGestureRecognizerDirectionUp) ]) {
        swipeRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(gestureRecognizer:)];
        swipeRecognizer.direction = [item intValue];
        [self.view addGestureRecognizer:swipeRecognizer];
    }

}

#pragma mark Controls

-(IBAction)leftPressedDown:(id)sender
{
    _cLogic->left();
}

-(IBAction)rightPressedDown:(id)sender
{
    _cLogic->right();
}

-(IBAction)downPressedDown:(id)sender
{
    _cLogic->down();
}

-(IBAction)upPressedDown:(id)sender
{
    _cLogic->up();
}

-(IBAction)buttonPressUp:(id)sender
{
    _cLogic->stop();
}

#pragma mark -
#pragma mark Music Control

-(void) setMusicState
{
    NSString *pauseImageName = ([PCMediaPlayer sharedInstance].muteMusic  ?  @"musicMute" : @"music");
    [musicButton setBackgroundImage:[UIImage imageNamed:pauseImageName] forState:UIControlStateNormal];
}

-(IBAction)musicControl:(id)sender
{
    [[PCMediaPlayer sharedInstance] switchMusicState];
    [self setMusicState];
}

-(void) setSoundState
{
    NSString *pauseImageName = ( [PCMediaPlayer sharedInstance].muteSound ? @"soundMute" : @"sound");
    [soundButton setBackgroundImage:[UIImage imageNamed:pauseImageName] forState:UIControlStateNormal];
}


-(IBAction)soundControl:(id)sender
{
    [[PCMediaPlayer sharedInstance] switchSoundState];
    [self setSoundState];
}

#pragma mark -

#pragma mark Pause

-(void) setPlayPause:(BOOL) paused
{
    //[_cLogic setPlayPause:paused];
    [[PCMediaPlayer sharedInstance] setPaused:paused];
    [self.view setNeedsDisplay];
    gameView.paused = paused;
    NSString *pauseImageName = (paused ? @"playHighlighted" : @"pause");
    [playPauseButton setBackgroundImage:[UIImage imageNamed:pauseImageName] forState:UIControlStateNormal];
}

-(IBAction)playPause:(id)sender
{
    [self setPlayPause:!gameView.paused];
}

#pragma mark -

@end