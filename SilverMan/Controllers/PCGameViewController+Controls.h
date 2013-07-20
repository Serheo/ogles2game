//
//  PCGameViewController+Controls.h
//  SilverMan
//
//  Created by Willy on 02.02.13.
//  Copyright (c) 2013 Willy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PCGameViewController.h"

@interface PCGameViewController (Controls)

-(void) initializeControls;
-(void) setMusicState;
-(void) setSoundState;
-(IBAction)playPause:(id)sender;
-(void) setPlayPause:(BOOL) paused;
@end