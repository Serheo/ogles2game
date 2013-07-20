//
//  GameViewController.h
//  SilverMan
//
//  Created by Willy on 19.12.12.
//  Copyright (c) 2012 Willy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

#import "PCGameContollerProtocol.h"
#import "CPPLogic.h"
#import "PCGameView.h"
#import "PCGLViewDelegate.h"

@interface PCGameViewController : UIViewController <PCGameContollerProtocol, UIActionSheetDelegate>
{
    EAGLContext *context;
    PacMan::CPPLogic *_cLogic;
    PCGameView *gameView;
    IBOutlet UIButton *arrowUp, *arrowDown, *arrowLeft, *arrowRight;
    IBOutlet UIButton *playPauseButton, *stopButton;
    IBOutlet UIButton *soundButton, *musicButton;
}

@end
