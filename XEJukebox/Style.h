//
//  Style.h
//  XEJukebox
//
//  Created by Freddie Parks on 14/12/2015.
//  Copyright © 2015 Freddie. All rights reserved.
//

#define RGB(r,g,b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]

#define DISCREET 0

#if DISCREET
    #define PRIMARY_COLOUR [UIColor whiteColor]
    #define SECONDARY_COLOUR [UIColor whiteColor]

    #define PRIMARY_HIGHLIGHT_COLOUR [UIColor blackColor]
    #define SECONDARY_HIGHLIGHT_COLOUR [UIColor blackColor]
#else
    #define PRIMARY_COLOUR RGB(200.0, 20.0, 20.0)
    #define SECONDARY_COLOUR RGB(20.0, 200.0, 20.0)

    #define PRIMARY_HIGHLIGHT_COLOUR [UIColor whiteColor]
    #define SECONDARY_HIGHLIGHT_COLOUR RGB(200.0, 240.0, 200.0)
#endif

#define THEME_FONT (@"Cartoon Blocks Christmas")
#define LIST_FONT (@"Arial-BoldMT")

#define THEME_TRANSPARENCY 0.9
