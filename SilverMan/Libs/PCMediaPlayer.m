//
//  MediaPlayer.m
//  SilverMan
//
//  Created by Willy on 24.12.12.
//  Copyright (c) 2012 Willy. All rights reserved.
//

#import "PCMediaPlayer.h"

#define MUSIC_KEY @"PCMuteMusic"
#define SOUND_KEY @"PCMuteSound"

@implementation PCMediaPlayer

+ (PCMediaPlayer *)sharedInstance
{
    static dispatch_once_t once;
    static PCMediaPlayer *sharedInstance = nil;
    dispatch_once(&once, ^{
        sharedInstance = [[PCMediaPlayer alloc] init];
  
        // pre initialize ding
        CFBundleRef mainBundle = CFBundleGetMainBundle();
        CFURLRef soundFileURLRef = CFBundleCopyResourceURL(mainBundle, CFSTR("coinDrop"), CFSTR("mp3"), NULL);
        SystemSoundID soundId;
        AudioServicesCreateSystemSoundID(soundFileURLRef, &soundId);
        CFRelease(soundFileURLRef);
    });
    
    return sharedInstance;
}

-(AVAudioPlayer *) createPlayer:(NSString *)path
{
    if (audioPlayer) [audioPlayer stop];
    
    NSURL *songURL = [NSURL URLWithString: [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *avPlayerError = nil;
    AVAudioPlayer *player = [[AVAudioPlayer alloc]initWithContentsOfURL:songURL error:&avPlayerError];
    player.numberOfLoops = -1;
    if (avPlayerError)
    {
        NSLog(@"Error: %@", [avPlayerError description]);
        return nil;
    }
    return player;
}

#pragma mark Music Control 

-(void)playGameBackground
{
    if (audioPlayer) [audioPlayer stop];
    audioPlayer = [self createPlayer:[[NSBundle mainBundle] pathForResource:@"backgroundMusic" ofType:@"m4a"]];
    if (audioPlayer)
    {
        audioPlayer.currentTime = 1;
        [audioPlayer prepareToPlay];
        if (self.muteMusic) audioPlayer.volume = 0;
        else audioPlayer.volume = 1;
        [audioPlayer play];
    }
}

-(void) setPaused:(BOOL) pause
{
    if (!audioPlayer) return;
    if (pause)
        [audioPlayer pause];
    else
        [audioPlayer play];
}

-(void) stop
{
    if (audioPlayer) [audioPlayer stop];
    audioPlayer = nil;
}

-(void) switchMusicState
{
    self.muteMusic = !self.muteMusic;
    if (audioPlayer)
    {
        audioPlayer.volume = self.muteMusic ? 0.0 : 1.0;
    }
}

#pragma mark -
#pragma mark Sound Effects Control

-(void) coinDing
{
    if (self.muteSound) return;
    CFBundleRef mainBundle = CFBundleGetMainBundle();
    CFURLRef soundFileURLRef = CFBundleCopyResourceURL(mainBundle, CFSTR("coinDrop"), CFSTR("mp3"), NULL);
    SystemSoundID soundId;
    AudioServicesCreateSystemSoundID(soundFileURLRef, &soundId);
    AudioServicesPlaySystemSound(soundId);
    CFRelease(soundFileURLRef);
}

-(void) switchSoundState
{
    self.muteSound = !self.muteSound;
}

#pragma mark -
#pragma mark User Default Methods

-(BOOL) userDefaultsBool:(NSString *)path
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    BOOL result =  [prefs boolForKey:path];
    if( !result ) return NO;
    return  result;
}

-(void) setUserDefaultsBool:(BOOL)state path:(NSString *)path
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:state forKey:path];
    [prefs synchronize];
}

#pragma mark -
#pragma mark Sound & Music Mutex Property

-(BOOL) muteSound
{
    return [self userDefaultsBool:SOUND_KEY];
}
-(BOOL) muteMusic
{
    return [self userDefaultsBool:MUSIC_KEY];
}

-(void) setMuteMusic:(BOOL)muteMusic
{
    [self setUserDefaultsBool:muteMusic path:MUSIC_KEY];
}

-(void) setMuteSound:(BOOL)muteSound
{
    [self setUserDefaultsBool:muteSound path:SOUND_KEY];
}

#pragma mark -


@end
