//
//  LabeledSlider.m
//  Particle Box
//
//  Created by Jonah Hooper on 2013/06/09.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "LabeledSlider.h"

const float VERT_OFFSET = 5.f;
const float HORZ_OFFSET = 5.f;
const float DIST_BTW_LAB_SLR = 5.f;
const float LAB_SHARE_HEIGHT = 0.65f;

@implementation LabeledSlider

@synthesize slider;
@synthesize label;

-(id) initWithFrame:(CGRect)frame withTex:(NSString *)text {
    self = [super initWithFrame:frame];
    if (self) {
        CGRect labelFrame = CGRectMake(HORZ_OFFSET, VERT_OFFSET, frame.size.width - 2 * HORZ_OFFSET,
                                       LAB_SHARE_HEIGHT * frame.size.height - DIST_BTW_LAB_SLR);
        label = [[UILabel alloc] initWithFrame:labelFrame];
        CGRect sliderFrame = CGRectMake(HORZ_OFFSET, labelFrame.size.height + DIST_BTW_LAB_SLR
                                        , labelFrame.size.width, frame.size.height - labelFrame.size.height);
        
        slider = [[UISlider alloc] initWithFrame:sliderFrame];
        
        [label setText:text];
        [self addSubview:label];
        [self addSubview:slider];
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
