//
//  XEJTrackListView.m
//  XEJukebox
//
//  Created by Freddie on 12/12/2015.
//  Copyright © 2015 Freddie. All rights reserved.
//

#import "XEJTrackListView.h"

#import "objc/runtime.h"

// Caveat: Tracking time will have to be done using an NSTimer as kvo is not possible on currentTime
// could iterate through all properties

@interface XEJTrackListView () <UITableViewDataSource, UITableViewDelegate>

@property NSArray *tracks;

@property int currentlyPlayingIndex;

@end

@implementation XEJTrackListView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self setupView];
    
}

- (instancetype)init {
    
    if ( self = [super init] ) {
        
        [self setupView];
        
    }
    
    return self;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setupView {
    
    self.dataSource = self;
    self.delegate = self;
    
    [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    //self.backgroundColor = [SECONDARY_COLOUR colorWithAlphaComponent:THEME_TRANSPARENCY];
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    
}

- (void)updateWithTracks:(NSArray *)tracks {
    
    self.tracks = tracks;
    [self reloadData];
    
}

#pragma mark - Table DMs-

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    
    return self.tracks.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self numberOfRowsInSection:section];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)numberOfSections {
    
    return [self numberOfSectionsInTableView:self];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ( self.listDelegate ) {
        [self.listDelegate selectedItemAtIndex:(int)indexPath.row];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *track = [self.tracks objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    NSString *titlePrefix = @"";
    UIColor *textColour = [UIColor blackColor];
    if ( indexPath.row == self.currentlyPlayingIndex ) {
        titlePrefix = @"(Now Playing) ";
        textColour = PRIMARY_COLOUR;
    }
    
    NSString *cellTitle = [NSString stringWithFormat:@"%@%@", titlePrefix, [[track objectForKey:@"title"] stringByReplacingOccurrencesOfString:@"_" withString:@" "]];
    
    cell.textLabel.text = cellTitle;
    cell.textLabel.font = [UIFont fontWithName:LIST_FONT size:17.0];
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.textColor = textColour;
    cell.contentView.backgroundColor = cell.backgroundColor = [UIColor clearColor];
    
    return cell;
    
}

- (void)listRequiresInsets:(UIEdgeInsets)insets {
    
    [self setContentInset:insets];
    
}

- (void)startedPlayingTrackAtIndex:(int)index {
    
    self.currentlyPlayingIndex = index;
    [self reloadData];
    [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

@end
