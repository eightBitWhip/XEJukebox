//
//  XEJTrackListView.h
//  XEJukebox
//
//  Created by Freddie on 12/12/2015.
//  Copyright © 2015 Freddie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XEJTrackListProtocol <NSObject>

- (void)selectedItemAtIndex:(int)index;

@end

@interface XEJTrackListView : UITableView

@property id<XEJTrackListProtocol>listDelegate;

- (void)updateWithTracks:(NSArray*)tracks;
- (void)listRequiresInsets:(UIEdgeInsets)insets;
- (void)startedPlayingTrackAtIndex:(int)index;

@end
