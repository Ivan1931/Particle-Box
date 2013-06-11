//
//  OptionPane.m
//  Particle Box
//
//  Created by Jonah Hooper on 2013/06/08.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "OptionPane.h"

#define N_COL_SLDRS 3
#define GAP_BTW_SLDRS 10.f

@implementation OptionPane

@synthesize sldrColors;
@synthesize sldrThickness;
@synthesize sldrNumParticle;
@synthesize sldrVelocity;
@synthesize btnExit;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        float OFFSET = self.bounds.size.height / 13;
        float X_OFFSET = self.bounds.size.width / 13;
        float SLDR_HEIGHT = self.bounds.size.height / 5;
        float SLDR_WIDTH = 130.f;
        [self setBackgroundColor:[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:1.f]];
        sldrColors = [[NSMutableArray alloc] init];
        NSArray *labelText = [[NSArray alloc] initWithObjects:@RED_STR, @GREEN_STR, @BLUE_STR,  nil];
        float default_colors[3] = {DEFAULT_RED,DEFAULT_GREEN,DEFAULT_BLUE};
        LabeledSlider *tmp;
        for (int i = 0 ; i < N_COL_SLDRS; i++) {
            CGRect sliderFrame = CGRectMake(X_OFFSET, OFFSET + (GAP_BTW_SLDRS + SLDR_HEIGHT) * i, SLDR_WIDTH, SLDR_HEIGHT);
            tmp = [[LabeledSlider alloc] initWithFrame:sliderFrame withTex:[labelText objectAtIndex:i]];
            [tmp.slider setMinimumValue:0.f];
            [tmp.slider setMaximumValue:1.f];
            [tmp.slider setValue:default_colors[i]];
            [tmp.label setBackgroundColor:self.backgroundColor];
            [tmp.label setTextColor:[UIColor whiteColor]];
            [tmp.slider addTarget:self action:@selector(updateComponentsColor) forControlEvents:UIControlEventValueChanged];
            [self addSubview:tmp];
            [sldrColors addObject:tmp];
        }
        CGRect thicknessFrame = CGRectMake(X_OFFSET * 2 + SLDR_WIDTH, OFFSET, SLDR_WIDTH, SLDR_HEIGHT);
        sldrThickness = [[LabeledSlider alloc] initWithFrame:thicknessFrame withTex:@THICKNESS_STR];
        [sldrThickness.slider setMinimumValue:1.f];
        [sldrThickness.slider setMaximumValue:MAX_THICKNESS];
        [sldrThickness.label setTextColor:[UIColor whiteColor]];
        [sldrThickness.label setBackgroundColor:self.backgroundColor];
        [sldrThickness.slider setValue:DEFAULT_THICKNESS];
        [self addSubview:sldrThickness];

        CGRect numParticlesFrame = CGRectMake(thicknessFrame.origin.x,
                                              thicknessFrame.origin.y + GAP_BTW_SLDRS + thicknessFrame.size.height, SLDR_WIDTH, SLDR_HEIGHT);
        sldrNumParticle = [[LabeledSlider alloc] initWithFrame:numParticlesFrame withTex:@NUM_PARTICLES_STR];
        [sldrNumParticle.slider setMinimumValue:MIN_PARTICLES];
        [sldrNumParticle.slider setMaximumValue:MAX_PARTICLES];
        [sldrNumParticle.label setBackgroundColor:self.backgroundColor];
        [sldrNumParticle.label setTextColor:[UIColor whiteColor]];
        [sldrNumParticle.slider setValue:DEFAULT_INITIAL_PARTICLES];
        [self addSubview:sldrNumParticle];

        CGRect velocityFrame = CGRectMake(numParticlesFrame.origin.x,
                                  numParticlesFrame.origin.y + GAP_BTW_SLDRS + numParticlesFrame.size.height, SLDR_WIDTH, SLDR_HEIGHT);
        sldrVelocity = [[LabeledSlider alloc] initWithFrame:velocityFrame withTex:@VELOCITY_STR];
        [sldrVelocity.slider setMinimumValue:MIN_VELOCITY_MULTIPLYER];
        [sldrVelocity.slider setMaximumValue:MAX_VELOCITY_MULTIPLYER];
        [sldrVelocity.label setBackgroundColor:self.backgroundColor];
        [sldrVelocity.label setTextColor:[UIColor whiteColor]];
        [sldrVelocity.slider setValue:DEFAULT_VEL_MULT];
        [self addSubview:sldrVelocity];

        CGRect buttonFrame = CGRectMake(0,
                                frame.size.height / 9 * 7, frame.size.width, frame.size.height / 14);
        
        btnExit = [[GradientButton alloc] initWithFrame:buttonFrame];
        btnExit.frame = buttonFrame;
        [btnExit setTitle:@EXIT_STR forState:UIControlStateNormal];
        [self addSubview:btnExit];
        
        labOptions = [[UILabel alloc] initWithFrame:CGRectMake(X_OFFSET, OFFSET / 2, self.bounds.size.width / 2, self.bounds.size.height / 20)];
        [labOptions setText:@"Options"];
        [labOptions sizeToFit];
        [labOptions setBackgroundColor:self.backgroundColor];
        [labOptions setTextColor:[UIColor whiteColor]];
        [self addSubview:labOptions];
        
        [self updateComponentsColor];


    }
    return self;
}

-(void) updateComponentsColor {
    float red = ((LabeledSlider *)[sldrColors objectAtIndex:0]).slider.value;
    float green = ((LabeledSlider *)[sldrColors objectAtIndex:1]).slider.value;
    float blue = ((LabeledSlider *)[sldrColors objectAtIndex:2]).slider.value;
    UIColor *reverseColor = [UIColor colorWithRed:1.f - red green:1.f - green blue:1.f - blue alpha:1.f];
    UIColor *actualColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.f];
    [btnExit setBackgroundColor:actualColor];
    [btnExit.titleLabel setTextColor:reverseColor];
    [labOptions setTextColor:actualColor];
    for (int i = 0 ; i < 3; i ++)
         [((LabeledSlider *) [sldrColors objectAtIndex:i]).label setTextColor:actualColor];
    [sldrThickness.label setTextColor:actualColor];
    [sldrVelocity.label setTextColor:actualColor];
    [sldrNumParticle.label setTextColor:actualColor];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
