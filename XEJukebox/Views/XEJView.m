//
//  XEJView.m
//  XEJukebox
//
//  Created by Freddie on 12/12/2015.
//  Copyright © 2015 Freddie. All rights reserved.
//

#import "XEJView.h"

@interface XEJView ()

@property UIActivityIndicatorView *loading;

@property UILabel *status, *currentT, *durationT;

@end

@implementation XEJView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self setupViews];
    [self style];
    
}

- (void)setupViews {
    
    for ( UIView *subView in self.subviews ) {
        
        if ( [subView isKindOfClass:[UILabel class]] ) {
            
            switch (subView.tag) {
                case 0:
                    self.status = (UILabel*)subView;
                    break;
                    
                case 1:
                    self.currentT = (UILabel*)subView;
                    break;
                    
                case 2:
                    self.durationT = (UILabel*)subView;
                    break;
                    
                default:
                    break;
            }
        }
        
    }
    
    self.loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.loading.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
    self.loading.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:self.loading];
    [self.loading startAnimating];
    
}

- (void)style {
    
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:THEME_TRANSPARENCY];
    
    self.status.font = [UIFont fontWithName:THEME_FONT size:30.0];
    
    self.currentT.textColor = [UIColor blackColor];
    self.durationT.textColor = [UIColor blackColor];
    
    UIView *completion = self.progressWidthConstraint.firstItem;
    completion.backgroundColor = [SECONDARY_COLOUR colorWithAlphaComponent:0.6];
    
    //self.status.textColor = SECONDARY_HIGHLIGHT_COLOUR;
    self.layer.borderWidth = 2.0;
    self.layer.borderColor = PRIMARY_COLOUR.CGColor;
    
}

- (void)updateWithMessage:(NSString *)message {
    
    self.status.text = [message stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    [self.loading stopAnimating];
    
}

- (void)updatedTrackProgress:(float)fraction withCurrentTime:(NSString *)currentTime andDuration:(NSString *)duration {
    
    self.currentT.text = currentTime;
    self.durationT.text = duration;
    
    UIView *completionView = self.progressWidthConstraint.firstItem;
    CGFloat newWidth = completionView.superview.frame.size.width * fraction;
    self.progressWidthConstraint.constant = newWidth;
    
}

@end
