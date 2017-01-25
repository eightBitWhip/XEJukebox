//
//  XEJControlsView.h
//  XEJukebox
//
//  Created by Freddie on 12/12/2015.
//  Copyright © 2015 Freddie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XEJControlsProtocol <NSObject>

- (void)nextTrack;
- (void)previousTrack;
- (void)play;
- (void)pause;

@end

@interface XEJControlsView : UIView

@property id<XEJControlsProtocol>controlsDelegate;

- (void)updatePlaying:(BOOL)playing;

@end
