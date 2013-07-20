//
//  GameViewController.m
//  SilverMan
//
//  Created by Willy on 19.12.12.
//  Copyright (c) 2012 Willy. All rights reserved.
//

#import "PCGameViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PCGameViewController+Controls.h"
#import "PCGameViewController+GLDraw.h"

@implementation PCGameViewController

#pragma mark Life Cycle

-(void) applicationDidBecomeActive:(NSNotification *)aNotification
{
    [self setPlayPause:YES];
}

-(void) applicationDidBecomeInActive:(NSNotification *)aNotification
{
    [self setPlayPause:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeInActive:) name:UIApplicationWillResignActiveNotification object:nil];
    
    [self initializeControls];
}

- (void) gestureRecognizer:(UISwipeGestureRecognizer *)sender {
    if ( sender.direction == UISwipeGestureRecognizerDirectionLeft )
        _cLogic->left();
    if ( sender.direction == UISwipeGestureRecognizerDirectionRight )
        _cLogic->right();
    if ( sender.direction == UISwipeGestureRecognizerDirectionDown )
        _cLogic->down();
    if ( sender.direction == UISwipeGestureRecognizerDirectionUp )
        _cLogic->up();
}


-(void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (!gameView)
    {
        float scale = [UIScreen mainScreen].scale;
        CGRect rc = self.view.bounds;
        PCFSize _size = {rc.size.width*scale, rc.size.height*scale};
        
        gameView = [[PCGameView alloc]initWithFrame:rc delegate:((id<PCGLViewDelegate>)self)];
        _cLogic = new PacMan::CPPLogic(_size, self);
        [self.view insertSubview:gameView atIndex:0];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[PCMediaPlayer sharedInstance] playGameBackground];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[PCMediaPlayer sharedInstance] stop];
}

-(void) viewWillDisappear:(BOOL)animated
{
    gameView.paused = YES;
    [super viewWillDisappear:animated];
}

-(void) goodbye
{
    if (_cLogic) delete _cLogic;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark Exit

-(IBAction)resetClicked:(id)sender
{
    [self setPlayPause:YES];
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Are you sure?"
                                                      message:@"All progress will be lost."
                                                     delegate:self
                                            cancelButtonTitle:@"NO"
                                            otherButtonTitles:@"YES", nil];
    [message show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) return;
    [self dismissViewControllerAnimated:YES completion:nil];
    [self goodbye];
}

#pragma mark -
#pragma mark Finish Game

-(void) level:(NSString *)levelName didFinishWithResult:(BOOL)success
{
    [self setPlayPause:YES];
    [self showEndGame:success];
}

-(void) showEndGame:(BOOL) success
{
    NSString *result = success ? @"You Won!" : @"Nice Try!";
    UIActionSheet *popupDialog = [[UIActionSheet alloc] initWithTitle:result delegate:self cancelButtonTitle:nil
                                              destructiveButtonTitle:nil otherButtonTitles:@"Again?", @"Menu", nil];
   
    [popupDialog showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self goodbye];
    }
    else
    {
        if (_cLogic) delete _cLogic;
        
        float scale = [UIScreen mainScreen].scale;
        CGRect rc = self.view.bounds;
        PCFSize _size = {rc.size.width*scale, rc.size.height*scale};
        _cLogic = new PacMan::CPPLogic(_size, self);

        [self setPlayPause:NO];
    }
}

#pragma mark -

@end
