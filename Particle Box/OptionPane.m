//
//  OptionPane.m
//  Particle Box
//
//  Created by Jonah Hooper on 2013/06/08.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "OptionPane.h"

#define N_COL_SLDRS 4
#define OFFSET 10.f
#define GAP_BTW_SLDRS 20.f
#define SLDR_WIDTH 100.f
#define SLDR_HEIGHT 80.f

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
        [self setBackgroundColor:[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:1.f]];
        sldrColors = [[NSMutableArray alloc] init];
        NSArray *labelText = [[NSArray alloc] initWithObjects:@RED_STR, @GREEN_STR, @BLUE_STR, @OPACITY_STR,  nil];
        LabeledSlider *tmp;
        for (int i = 0 ; i < N_COL_SLDRS; i++) {
            CGRect sliderFrame = CGRectMake(OFFSET, OFFSET + (GAP_BTW_SLDRS + SLDR_HEIGHT) * i, SLDR_WIDTH, SLDR_HEIGHT);
            tmp = [[LabeledSlider alloc] initWithFrame:sliderFrame withTex:[labelText objectAtIndex:i]];
            [tmp.slider setMinimumValue:0.f];
            [tmp.slider setMaximumValue:1.f];
            [tmp.label setBackgroundColor:self.backgroundColor];
            [tmp.label setTextColor:[UIColor whiteColor]];
            [self addSubview:tmp];
            [sldrColors addObject:tmp];
        }
        CGRect thicknessFrame = CGRectMake(OFFSET * 2 + SLDR_WIDTH, OFFSET, SLDR_WIDTH, SLDR_HEIGHT);
        sldrThickness = [[LabeledSlider alloc] initWithFrame:thicknessFrame withTex:@THICKNESS_STR];
        [sldrThickness.slider setMinimumValue:1.f];
        [sldrThickness.slider setMaximumValue:MAX_THICKNESS];
        [sldrThickness.label setTextColor:[UIColor whiteColor]];
        [sldrThickness.label setBackgroundColor:self.backgroundColor];
        [self addSubview:sldrThickness];

        CGRect numParticlesFrame = CGRectMake(thicknessFrame.origin.x,
                                              thicknessFrame.origin.y + GAP_BTW_SLDRS + thicknessFrame.size.height, SLDR_WIDTH, SLDR_HEIGHT);
        sldrNumParticle = [[LabeledSlider alloc] initWithFrame:numParticlesFrame withTex:@THICKNESS_STR];
        [sldrNumParticle.slider setMinimumValue:MIN_PARTICLES];
        [sldrNumParticle.slider setMaximumValue:MAX_PARTICLES];
        [sldrNumParticle.label setBackgroundColor:self.backgroundColor];
        [sldrNumParticle.label setTextColor:[UIColor whiteColor]];
        [self addSubview:sldrNumParticle];

        CGRect velocityFrame = CGRectMake(numParticlesFrame.origin.x,
                                  numParticlesFrame.origin.y + GAP_BTW_SLDRS + numParticlesFrame.size.height, SLDR_WIDTH, SLDR_HEIGHT);
        sldrVelocity = [[LabeledSlider alloc] initWithFrame:velocityFrame withTex:@VELOCITY_STR];
        [sldrVelocity.slider setMinimumValue:MIN_VELOCITY_MULTIPLYER];
        [sldrVelocity.slider setMaximumValue:MAX_VELOCITY_MULTIPLYER];
        [sldrVelocity.label setBackgroundColor:self.backgroundColor];
        [sldrVelocity.label setTextColor:[UIColor whiteColor]];
        [self addSubview:sldrVelocity];

        CGRect buttonFrame = CGRectMake(frame.size.width / 4 * 3,
                                frame.size.height / 9 * 7, frame.size.width / 6, frame.size.height / 14);
        btnExit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnExit.frame = buttonFrame;
        btnExit.titleLabel.text = @EXIT_STR;
        [btnExit.titleLabel setTextColor:[UIColor whiteColor]];
        [btnExit setBackgroundColor:self.backgroundColor];
        [btnExit.titleLabel setBackgroundColor:self.backgroundColor];
        [self addSubview:btnExit];

    }
    return self;
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
