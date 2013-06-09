//
//  OptionPane.h
//  Particle Box
//
//  Created by Jonah Hooper on 2013/06/08.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LabeledSlider.h"

#define RED_STR "Red"
#define GREEN_STR "Green"
#define BLUE_STR "Blue"
#define OPACITY_STR "Opaque"
#define EXIT_STR "Exit"
#define VELOCITY_STR "Velocity"
#define NUM_PARTICLES_STR "Number of Particles"
#define THICKNESS_STR "Thickness"

@interface OptionPane : UIView {
    NSMutableArray *sldrColors;
    LabeledSlider *sldrVelocity;
    LabeledSlider *sldrNumParticle;
    LabeledSlider *sldrThickness;
    UIButton *btnExit;
}

@property (nonatomic, strong) NSMutableArray *sldrColors;
@property (nonatomic, strong) LabeledSlider *sldrVelocity;
@property (nonatomic, strong) LabeledSlider *sldrNumParticle;
@property (nonatomic, strong) LabeledSlider *sldrThickness;
@property (nonatomic, strong) UIButton *btnExit;

@end
