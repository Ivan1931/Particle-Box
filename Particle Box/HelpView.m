//
//  HelpView.m
//  Particle Box
//
//  Created by Jonah Hooper on 2013/06/21.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "HelpView.h"


@implementation HelpView

@synthesize btnExit;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor blackColor]];
        
        NSArray *imgStrings = [NSArray arrayWithObjects:@PLUS_IMG_STR, @MINUS_IMG_STR, @SETTINGS_IMG_STR, @STICKY_BTN_IMG_STR, nil];
        NSArray *idStrings = [NSArray arrayWithObjects:PLUS_OPT_STR, MINUS_OPT_STR, SETTING_OPT_STR, STICKY_FINGERS_STR, nil];
        UIImageView *imgTmp;
        UILabel *labTmp;
        
        float componentHeight = frame.size.width * SCREEN_TO_COMP_RATIO;
        float imgWidth = componentHeight;
        float labWidth = frame.size.width - imgWidth - COMPONENT_GAP;
        
        labShake = [[UILabel alloc] initWithFrame:CGRectMake(5.f, COMPONENT_GAP, frame.size.width, componentHeight)];
        [labShake setBackgroundColor:self.backgroundColor];
        [labShake setTextColor:[UIColor whiteColor]];
        [labShake setText:(NSString*)SHAKE_OPT_STR];
        [self addSubview:labShake];
        
        for (int i = 0 ; i < [idStrings count]; i++) {
            float layerHeight = (i + 1) * (componentHeight + COMPONENT_GAP);
            CGRect imgFrame = CGRectMake(0.f, layerHeight, imgWidth, componentHeight);
            NSString *imgString = (NSString*)[imgStrings objectAtIndex:i];
            imgTmp = [[UIImageView alloc] initWithFrame:imgFrame];
            [imgTmp setImage:[UIImage imageNamed:imgString]];
            [self addSubview:imgTmp];
            [imgOptionImages addObject:imgTmp];
            
            CGRect labFrame = CGRectMake(imgWidth + COMPONENT_GAP, layerHeight, labWidth, componentHeight);
            NSString *labString = (NSString *)[idStrings objectAtIndex:i];
            labTmp = [[UILabel alloc] initWithFrame:labFrame];
            [labTmp setText:labString];
            [labTmp setTextColor:[UIColor whiteColor]];
            [labTmp setBackgroundColor:[UIColor blackColor]];
            [labTmp setNumberOfLines:3];
            [labTmp sizeToFit];
            [self addSubview:labTmp];
            [labHelpOptions addObject:labTmp];
        }
        
        btnExit = [[GradientButton alloc] initWithFrame:CGRectMake(COMPONENT_GAP, frame.size.height - componentHeight - COMPONENT_GAP * 4,
                                                                   frame.size.width - 2 * COMPONENT_GAP, componentHeight)];
        [btnExit setBackgroundColor:[UIColor blackColor]];
        [btnExit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnExit setTitle:@"Done" forState:UIControlStateNormal];
        [self addSubview:btnExit];
        
    }
    return self;
}


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
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
