//
//  XEJService.m
//  XEJukebox
//
//  Created by Freddie on 12/12/2015.
//  Copyright © 2015 Freddie. All rights reserved.
//

#import "XEJService.h"

//#import "objc/runtime.h"

#import <AVFoundation/AVFoundation.h>

#define JUKEBOX_URL (@"http://www.x-entertainment.com/xmasjukey/wimpy.php?action=getstartupdirlist&getMyid3info=no&defaultVisualExt=jpg&defaultVisualBaseName=coverart&s=undefined")

#define SPACE_ENCODE (@"%20")

@interface XEJService ()

@property AVPlayer *player;

@property NSArray *tracks, *trackInfo;

@property NSTimer *updateTimer;

@end

@implementation XEJService

- (instancetype)init {
    
    if ( self = [super init] ) {
        
        /*unsigned int outCount, i;
        objc_property_t *properties = class_copyPropertyList([AVPlayer class], &outCount);
        for(i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            const char *propName = property_getName(property);
            NSLog(@"Found property %@", [NSString stringWithUTF8String:propName]);
        }*/
        
        [self grabData];
        
    }
    
    return self;
    
}

- (instancetype)initWithDelegate:(id<XEJServiceProtocol>)delegate {
    
    self.serviceDelegate = delegate;
    
    if ( self = [self init] ) {
        
    }
    
    return self;
    
}

- (void)setupPlayerWithSongs:(NSArray*)songs {
    
    NSMutableArray *songItems = [NSMutableArray new];
    
    for ( NSDictionary *song in songs ) {
        
        if ( [song objectForKey:@"url"] ) {
            NSString *urlString = [[song objectForKey:@"url"] stringByReplacingOccurrencesOfString:@" " withString:SPACE_ENCODE];
            AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:urlString]];
            if ( item ) [songItems addObject:item];
            else NSLog(@"Problem with url: %@", [song objectForKey:@"url"]);
        }
        
    }
    
    if ( songItems.count > 0 ) {
        
        self.tracks = [NSArray arrayWithArray:songItems];
        self.player = [[AVPlayer alloc] initWithPlayerItem:self.tracks[0]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:nil];
        [self.player addObserver:self forKeyPath:@"status" options:0 context:nil];
        
    }
    
    if ( self.serviceDelegate ) [self.serviceDelegate gotSongs:songs];
    
    self.trackInfo = songs.copy;
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == self.player && [keyPath isEqualToString:@"status"]) {
        if (self.player.status == AVPlayerStatusFailed) {
            NSLog(@"AVPlayer Failed");
        } else if (self.player.status == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            
            [self.player play];
            if ( self.serviceDelegate ) {
                [self.serviceDelegate startedPlayingTrackWithTitle:[[self.trackInfo objectAtIndex:0] objectForKey:@"title"]];
                [self.serviceDelegate startedPlayingTrackAtIndex:0];
            }
            [self checkPlayerStatus];
            
        } else if (self.player.status == AVPlayerItemStatusUnknown) {
            NSLog(@"AVPlayer Unknown");
        }
    }
}

- (void)playerItemDidReachEnd:(NSNotification*)notification {
    
    [self nextTrack];
    
}

- (void)checkPlayerStatus {
    
    if ( self.player && self.player.currentItem ) {
        
        if ( self.updateTimer.valid == NO ) {
            self.updateTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(checkPlayerStatus) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.updateTimer forMode:NSRunLoopCommonModes];
        }
        
        AVPlayerItem *item = self.player.currentItem.copy;
        float duration = CMTimeGetSeconds(item.duration);
        float current = CMTimeGetSeconds(self.player.currentTime);
        float completion = 0.0;
        if ( duration >= 0.0 && current >= 0.0 ) {
            completion = (1.0 / duration) * current;
        }
        
        NSDateFormatter *timerFormatter = [[NSDateFormatter alloc] init];
        [timerFormatter setDateFormat:@"m:ss"];
        
        NSString *currentString = [timerFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:current]];
        NSString *durationString = [timerFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:duration]];
        
        if ( currentString && durationString ) {
        
            NSLog(@"CURRENT ITEM:\n\n%@\n\n%@\n\n%@", item, currentString, durationString);
            if ( self.serviceDelegate ) {
                [self.serviceDelegate trackCurrentTimeIs:currentString withTotalDuration:durationString andCompletion:completion];
            }
            
        }
        
    }
    
}

- (void)changeTrackToTrackAtIndex:(int)index {
    
    AVPlayerItem *item = self.tracks[index];
    [item seekToTime:CMTimeMake(0, 1)];
    [self.player replaceCurrentItemWithPlayerItem:item];
    [self play];
    
    if ( self.serviceDelegate ) {
        [self.serviceDelegate startedPlayingTrackWithTitle:[[self.trackInfo objectAtIndex:index] objectForKey:@"title"]];
        [self.serviceDelegate startedPlayingTrackAtIndex:index];
    }
    
}

- (void)play {
    
    [self.player play];
    
}

- (void)pause {
    
    [self.player pause];
    
}

- (void)nextTrack {
    
    int index = (int)[self.tracks indexOfObject:self.player.currentItem]+1;
    if ( index == self.tracks.count ) index = 0;
    [self changeTrackToTrackAtIndex:index];
    
}

- (void)previousTrack {
    
    int index = (int)[self.tracks indexOfObject:self.player.currentItem]-1;
    if ( index == -1 ) index = (int)self.tracks.count-1;
    [self changeTrackToTrackAtIndex:index];
    
}

- (void)grabData {
    
    NSData *jukeyData = [NSData dataWithContentsOfURL:[NSURL URLWithString:JUKEBOX_URL]];
    if ( jukeyData && jukeyData != nil ) {
        
        NSString *jukeyString = [NSString stringWithUTF8String:jukeyData.bytes];
        NSLog(@"JS %@", jukeyString);
        
        NSArray *songs = [jukeyString componentsSeparatedByString:@"|||||||"];
        if ( songs.count > 0 ) {
            
            NSMutableArray *songDics = [NSMutableArray new];
            
            for ( NSString *songString in songs ) {
                
                NSArray *songParts = [songString componentsSeparatedByString:@"|"];
                if ( songParts.count == 4 ) {
                    
                    NSArray *urlParts = [songParts[0] componentsSeparatedByString:@"="];
                    if ( urlParts.count >= 2 ) {
                        
                        NSString *urlString = [self urlDecodedString:urlParts[1]];
                        NSString *titleString = [self urlDecodedString:songParts[1]];
                        NSDictionary *songDic = @{@"title":titleString, @"url":urlString};
                        [songDics addObject:songDic];
                        
                        NSLog(@"added a track %@\n", songDic);
                        
                    }
                    
                }
                
            }
            
            if ( songDics.count > 0 ) {
                [self setupPlayerWithSongs:[NSArray arrayWithArray:songDics]];
            }
            
        }
        
    }
    
}

#define DECODE_URLS 1

- (NSString*)urlDecodedString:(NSString*)string {
    
    if ( !DECODE_URLS ) return string;
    
    NSString *decodedString = [string stringByReplacingOccurrencesOfString:@"+" withString:@""];
    decodedString = [decodedString stringByRemovingPercentEncoding];
    
    return decodedString;
    
}

@end
