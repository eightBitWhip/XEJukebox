//
//  XEJView.h
//  XEJukebox
//
//  Created by Freddie on 12/12/2015.
//  Copyright © 2015 Freddie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XEJView : UIView

@property IBOutlet NSLayoutConstraint *progressWidthConstraint;

- (void) updateWithMessage:(NSString*)message;
- (void)updatedTrackProgress:(float)fraction withCurrentTime:(NSString*)currentTime andDuration:(NSString*)duration;

@end
