//
//  HelpView.h
//  Particle Box
//
//  Created by Jonah Hooper on 2013/06/21.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GradientButton.h"

static const NSString *STICKY_FINGERS_STR = @"Toggling this button will cycle through modes that create effects when you lift your fingers. Tap to check them out";
static const NSString *PLUS_OPT_STR = @"Select to change to the next force mode";
static const NSString *MINUS_OPT_STR = @"Select to change to the previous force mode";
static const NSString *SETTING_OPT_STR = @"Select to open an option menu";
static const NSString *SHAKE_OPT_STR = @"Shake your device to reset the particles";

static const float SCREEN_TO_COMP_RATIO = 1.f / 6.f;

static const float COMPONENT_GAP = 10.f;

@interface HelpView : UIView {
    NSMutableArray *imgOptionImages;
    NSMutableArray *labHelpOptions;
    UILabel *labShake;
    GradientButton *btnExit;
}

@property (nonatomic, strong) GradientButton *btnExit;

@end
