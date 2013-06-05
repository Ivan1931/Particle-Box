//
//  SmallMenuView.m
//  Particle Box
//
//  Created by Jonah Hooper on 2013/06/04.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "SmallMenuView.h"
#define CAMMERA_BTN_IMG_STR "cammera.png"

@implementation SmallMenuView

@synthesize btnHelp;
@synthesize btnOpenOptions;
@synthesize btnPurchase;
@synthesize btnScreenShot;
@synthesize btnStepUpMode;

-(id) initWithFrame:(CGRect) frame forceMode:(int) mode {
    self = [super initWithFrame:frame];
    if (self) {
        float size = frame.size.height;
        float gap = 5.f;
        float totalSpacing = size + gap;
        
        btnStepUpMode = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, size, size)];
        [btnStepUpMode setTitle:[NSString stringWithFormat:@"  %d",mode] forState:UIControlStateNormal];
        btnStepUpMode.titleLabel.font = [UIFont fontWithName:@"Ariel" size:50];
        btnStepUpMode.titleLabel.textColor = [UIColor whiteColor];
        [btnStepUpMode setBackgroundColor:[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.f]];
        [self addSubview:btnStepUpMode];
        
        [self addUIButton:btnScreenShot : CGRectMake(totalSpacing * 1.f, 0.f
                                                     , size, size):@CAMMERA_BTN_IMG_STR];
        
        [self addUIButton:btnOpenOptions : CGRectMake(totalSpacing * 2.f, 0.f
                                                      , size, size):@"Untitled.png"];
        
        [self addUIButton:btnPurchase : CGRectMake(totalSpacing * 3.f, 0.f
                                                   , size, size):@"Untitled.png"];
        
        [self addUIButton:btnHelp : CGRectMake(totalSpacing * 4.f, 0.f
                                               , size, size):@"Untitled.png"];
        
                
        
    }
    return self;
}

-(void) addUIButton:(UIButton *)button :(CGRect)frame :(NSString*) imagePath{
    button = [[UIButton alloc] initWithFrame:frame];
    [button setBackgroundImage:[UIImage imageNamed:imagePath ] forState:UIControlStateNormal];
    [self addSubview:button];
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
