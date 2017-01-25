//
//  ViewController.m
//  XEJukebox
//
//  Created by Freddie on 12/12/2015.
//  Copyright © 2015 Freddie. All rights reserved.
//

#import "ViewController.h"

#import "XEJService.h"

#import "XEJView.h"
#import "XEJTrackListView.h"
#import "XEJControlsView.h"

@interface ViewController () <XEJServiceProtocol, XEJTrackListProtocol, XEJControlsProtocol>

@property (weak, nonatomic) IBOutlet XEJTrackListView *trackList;

@property (weak, nonatomic) IBOutlet XEJView *trackDetail;

@property (weak, nonatomic) IBOutlet XEJControlsView *controls;

@property XEJService *service;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIView *statusBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20.0)];
    statusBG.backgroundColor = [PRIMARY_COLOUR colorWithAlphaComponent:THEME_TRANSPARENCY];
    statusBG.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view insertSubview:statusBG aboveSubview:self.trackList];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(20.0, 0, 0, 0);
    
    [self.trackList listRequiresInsets:insets];
    
    UIImageView *lights = [[UIImageView alloc] initWithFrame:self.view.bounds];
    lights.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    lights.image = [UIImage imageNamed:@"lights.png"];
    
    [self.view insertSubview:lights belowSubview:self.trackList];
    
    for ( UIView *subView in self.view.subviews ) {
        if ( [subView isKindOfClass:[UIImageView class]] && subView.tag == 100 ) {
            [(UIImageView*)subView setImage:[UIImage imageNamed:@"christmas-holly.png"]];
        }
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    self.service = [[XEJService alloc] initWithDelegate:self];
    
    self.trackList.listDelegate = self;
    self.controls.controlsDelegate = self;
    
    UIEdgeInsets insets = UIEdgeInsetsMake(20.0, 0, self.controls.frame.size.height + self.trackDetail.frame.size.height, 0);
    
    [self.trackList listRequiresInsets:insets];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Service DMs-

- (void)gotSongs:(NSArray *)songs {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.trackList updateWithTracks:songs];
        
    });
    
}

- (void)startedPlayingTrackWithTitle:(NSString *)title {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.trackDetail updateWithMessage:title];
        
    });
    
}

- (void)startedPlayingTrackAtIndex:(int)index {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.trackList startedPlayingTrackAtIndex:index];
        [self.controls updatePlaying:YES];
        
    });
    
}

- (void)trackCurrentTimeIs:(NSString *)time withTotalDuration:(NSString *)duration andCompletion:(float)completionFraction {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // update details view
        [self.trackDetail updatedTrackProgress:completionFraction withCurrentTime:time andDuration:duration];
        
    });
    
}

#pragma mark - List DMs-

- (void)selectedItemAtIndex:(int)index {
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        [self.service changeTrackToTrackAtIndex:index];
    
    });
    
}

#pragma mark - Controls DMs-

- (void)nextTrack {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.service nextTrack];
        
    });
    
}

- (void)previousTrack {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.service previousTrack];
        
    });
    
}

- (void)play {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.service play];
        
    });
    
}

- (void)pause {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.service pause];
        
    });
    
}

#pragma mark - err-

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
    
}

@end
