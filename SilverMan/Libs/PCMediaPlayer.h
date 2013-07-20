//
//  MediaPlayer.h
//  SilverMan
//
//  Created by Willy on 24.12.12.
//  Copyright (c) 2012 Willy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface PCMediaPlayer : NSObject
{
     AVAudioPlayer *audioPlayer;
}
@property (readonly) BOOL muteSound;
@property (readonly) BOOL muteMusic;

+ (PCMediaPlayer *)sharedInstance;
-(void) playGameBackground;
-(void) setPaused:(BOOL) pause;
-(void) coinDing;
-(void) stop;

-(void) switchMusicState;
-(void) switchSoundState;

@end
