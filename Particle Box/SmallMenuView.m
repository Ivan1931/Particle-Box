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
@synthesize btnReset;
@synthesize btnNextMode;

-(id) initWithFrame:(CGRect) frame forceMode:(int) mode {
    self = [super initWithFrame:frame];
    if (self) {
        float size = frame.size.height;
        float gap = 5.f;
        float totalSpacing = size + gap;
        
        btnNextMode = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, size, size)];
        [btnNextMode setTitle:[NSString stringWithFormat:@"  %d",mode] forState:UIControlStateNormal];
        btnNextMode.titleLabel.font = [UIFont fontWithName:@"Ariel" size:50];
        btnNextMode.titleLabel.textColor = [UIColor whiteColor];
        [btnNextMode setBackgroundColor:[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.f]];
        [self addSubview:btnNextMode];
        
        btnReset = [[UIButton alloc] initWithFrame:CGRectMake(totalSpacing, 0.f, size, size)];
        [btnReset setImage:[UIImage imageNamed:@CAMMERA_BTN_IMG_STR ] forState:UIControlStateNormal];
        [self addSubview:btnReset];
        
        btnOpenOptions = [[UIButton alloc] initWithFrame: CGRectMake(totalSpacing * 2.f, 0.f, size, size)];
        [btnOpenOptions setBackgroundImage:[UIImage imageNamed:@"Untitled.png"] forState:UIControlStateNormal];
        [self addSubview:btnOpenOptions];
        
        btnPurchase = [[UIButton alloc] initWithFrame:CGRectMake(totalSpacing * 3.f, 0.f, size, size)];
        [btnPurchase setBackgroundImage:[UIImage imageNamed:@"Untitled.png"] forState:UIControlStateNormal];
        [self addSubview:btnPurchase];
        
        btnHelp = [[UIButton alloc] initWithFrame: CGRectMake(totalSpacing * 4.f, 0.f, size, size)];
        [btnHelp setBackgroundImage:[UIImage imageNamed:@"Untitled.png" ] forState:UIControlStateNormal];
        [self addSubview:btnHelp];
        
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
