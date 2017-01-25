//
//  XEJService.h
//  XEJukebox
//
//  Created by Freddie on 12/12/2015.
//  Copyright © 2015 Freddie. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XEJServiceProtocol <NSObject>

- (void)gotSongs:(NSArray*)songs;
- (void)startedPlayingTrackWithTitle:(NSString*)title;
- (void)startedPlayingTrackAtIndex:(int)index;
- (void)trackCurrentTimeIs:(NSString*)time withTotalDuration:(NSString*)duration andCompletion:(float)completionFraction;

@end

@interface XEJService : NSObject

@property id<XEJServiceProtocol>serviceDelegate;

- (instancetype)initWithDelegate:(id<XEJServiceProtocol>)delegate;

- (void)changeTrackToTrackAtIndex:(int)index;
- (void)play;
- (void)pause;
- (void)nextTrack;
- (void)previousTrack;

@end
