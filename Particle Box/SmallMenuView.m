//
//  SmallMenuView.m
//  Particle Box
//
//  Created by Jonah Hooper on 2013/06/04.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "SmallMenuView.h"
#define CAMMERA_BTN_IMG_STR "cammera.png"
#define FONT_SIZE 50
#define BORDER_WIDTH 2.f

@implementation SmallMenuView

//@synthesize btnHelp;
@synthesize btnOpenOptions;
@synthesize btnPurchase;
@synthesize btnReset;
@synthesize btnNextMode;

-(id) initWithFrame:(CGRect) frame forceMode:(int) mode {
    self = [super initWithFrame:frame];
    if (self) {
        float size = frame.size.height;
        float gap = frame.size.width / 20;
        float totalSpacing = size + gap;
        
        btnNextMode = [[UIButton alloc] initWithFrame:CGRectMake(gap, 0.f, size, size)];
        [btnNextMode setTitle:[NSString stringWithFormat:@"%d",(mode + 1)] forState:UIControlStateNormal];
        btnNextMode.titleLabel.font = [UIFont fontWithName:@"Ariel" size:FONT_SIZE];
        btnNextMode.titleLabel.textColor = [UIColor whiteColor];
        [btnNextMode setBackgroundColor:[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.f]];
        [btnNextMode.layer setBorderColor:[UIColor whiteColor].CGColor];
        [btnNextMode.layer setBorderWidth:BORDER_WIDTH];
        btnNextMode.layer.cornerRadius = 15; // this value vary as per your desire
        btnNextMode.clipsToBounds = YES;
        [self addSubview:btnNextMode];
        
        btnReset = [[UIButton alloc] initWithFrame:CGRectMake(gap + totalSpacing, 0.f, size, size)];
        [btnReset setBackgroundColor:[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.f]];
        [btnReset.titleLabel setTextColor:[UIColor whiteColor]];
        [btnReset setTitle:@"R" forState:UIControlStateNormal];
        btnReset.titleLabel.font = [UIFont fontWithName:@"Ariel" size:FONT_SIZE];
        [btnReset.layer setBorderColor:[UIColor whiteColor].CGColor];
        [btnReset.layer setBorderWidth:BORDER_WIDTH];
        btnReset.layer.cornerRadius = 10; // this value vary as per your desire
        btnReset.clipsToBounds = YES;
        [self addSubview:btnReset];
        
        btnOpenOptions = [[UIButton alloc] initWithFrame: CGRectMake(gap + totalSpacing * 2.f, 0.f, size, size)];
        [btnOpenOptions.titleLabel setTextColor:[UIColor whiteColor]];
        [btnOpenOptions setTitle:@"O" forState:UIControlStateNormal];
        btnOpenOptions.titleLabel.font = [UIFont fontWithName:@"Ariel" size:FONT_SIZE];
        [btnOpenOptions setBackgroundColor:self.backgroundColor];
        [btnOpenOptions.layer setBorderWidth:BORDER_WIDTH];
        [btnOpenOptions.layer setBorderColor:[UIColor whiteColor].CGColor];
        btnOpenOptions.layer.cornerRadius = 10; // this value vary as per your desire
        btnOpenOptions.clipsToBounds = YES;
        [self addSubview:btnOpenOptions];
        
        btnPurchase = [[UIButton alloc] initWithFrame:CGRectMake(gap + totalSpacing * 3.f, 0.f, size, size)];
        [btnPurchase setBackgroundColor:self.backgroundColor];
        [btnPurchase.layer setBorderColor:[UIColor whiteColor].CGColor];
        [btnPurchase.layer setBorderWidth:BORDER_WIDTH];
        [btnPurchase.titleLabel setTextColor:[UIColor whiteColor]];
        btnPurchase.titleLabel.font = [UIFont fontWithName:@"Ariel" size:FONT_SIZE];
        [btnPurchase setTitle:@"$" forState:UIControlStateNormal];
        btnPurchase.layer.cornerRadius = 10; // this value vary as per your desire
        btnPurchase.clipsToBounds = YES;
        [self addSubview:btnPurchase];
        
        
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
