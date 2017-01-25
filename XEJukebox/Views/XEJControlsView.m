//
//  XEJControlsView.m
//  XEJukebox
//
//  Created by Freddie on 12/12/2015.
//  Copyright © 2015 Freddie. All rights reserved.
//

#import "XEJControlsView.h"

@interface XEJControlsView ()

@property UIButton *playPauseButton;

@end

@implementation XEJControlsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self setupControls];
    
}

- (void)setupControls {
    
    self.backgroundColor = [PRIMARY_COLOUR colorWithAlphaComponent:THEME_TRANSPARENCY];
    
    for ( UIView *subView in self.subviews ) {
        
        [self setupSubViewsAndView:subView];
        
    }
    
}

- (void)setupSubViewsAndView:(UIView*)view {
    
    if ( [view isKindOfClass:[UIButton class]] ) {
        
        UIButton *button = (UIButton*)view;
        
        switch (button.tag) {
            case 1:
                [self styleControlButton:button withOptionalTitle:nil andOptionalImageName:@"skip_back.png"];
                [button addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(previous)]];
                break;
                
            case 2:
                [self styleControlButton:button withOptionalTitle:nil andOptionalImageName:@"pause.png"];
                [button addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(play:)]];
                self.playPauseButton = button;
                break;
                
            case 3:
                [self styleControlButton:button withOptionalTitle:nil andOptionalImageName:@"skip_forward.png"];
                [button addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(next)]];
                break;
                
            default:
                break;
        }
        
    }
    else if ( [view isKindOfClass:[UIView class]] ) {
        
        for ( UIView *subView in view.subviews ) {
            [self setupSubViewsAndView:subView];
        }
        
    }
    
}

- (void)next {
    
    if ( self.controlsDelegate ) {
        [self.controlsDelegate nextTrack];
    }
    
}

- (void)previous {
    
    if ( self.controlsDelegate ) {
        [self.controlsDelegate previousTrack];
    }
    
}

- (void)play:(UITapGestureRecognizer*)gez {
    
    UIButton *button = (UIButton*)gez.view;
    
    NSString *imageName = ( [button.imageView.image isEqual:[UIImage imageNamed:@"play.png"]] ) ? @"pause.png" : @"play.png";
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    if ( self.controlsDelegate ) {
        if ( [button.imageView.image isEqual:[UIImage imageNamed:@"play.png"]] ) {
            [self.controlsDelegate pause];
        }
        else {
            [self.controlsDelegate play];
        }
    }
    
}

- (void)updatePlaying:(BOOL)playing {
    
    NSString *imageName = ( playing == YES ) ? @"pause.png" : @"play.png";
    [self.playPauseButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self.playPauseButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    if ( self.controlsDelegate ) {
        if ( [self.playPauseButton.imageView.image isEqual:[UIImage imageNamed:@"play.png"]] ) {
            [self.controlsDelegate pause];
        }
        else {
            [self.controlsDelegate play];
        }
    }
    
}

- (void)styleControlButton:(UIButton*)button withOptionalTitle:(NSString*)title andOptionalImageName:(NSString*)image {
    
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    button.titleLabel.text = @"";
    [button setTitle:@"" forState:UIControlStateNormal];
    
    if ( title ) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    else if ( image ) {
        [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [button setTintColor:[UIColor clearColor]];
        [button setTitle:nil forState:UIControlStateNormal];
    }
    //[button setTitleColor:PRIMARY_HIGHLIGHT_COLOUR forState:UIControlStateNormal];
    //[button.titleLabel setFont:[UIFont fontWithName:THEME_FONT size:23.0]];
    
}

@end
