//
//  SmallMenuView.m
//  Particle Box
//
//  Created by Jonah Hooper on 2013/06/04.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "SmallMenuView.h"
#define CAMMERA_BTN_IMG_STR "cammera.png"
#define FONT_SIZE 70
#define BORDER_WIDTH 3.f

#define PLUS_IMG_STR "plus.png"
#define MINUS_IMG_STR "minu.png"
#define SETTINGS_IMG_STR "ios_setting cog.png"
#define Q_MARK_IMG_STR "qmark.png"

@implementation SmallMenuView

@synthesize btnOpenOptions;
@synthesize btnHelp;
@synthesize btnStickyFingers;
@synthesize btnNextMode;
@synthesize btnPreviousMode;

-(id) initWithFrame:(CGRect) frame forceMode:(int) mode {
    self = [super initWithFrame:frame];
    if (self) {
        float size = frame.size.height;
        float gap = frame.size.width / 22;
        float totalSpacing = size + gap;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        btnNextMode = [[UIButton alloc] initWithFrame:CGRectMake(gap, 0.f, size, size)];
        [btnNextMode setBackgroundColor:[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.f]];
        [btnNextMode setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
        btnNextMode.imageView.layer.cornerRadius = 10;
        btnNextMode.imageView.clipsToBounds = YES;
        [self addSubview:btnNextMode];
        
        btnPreviousMode = [[UIButton alloc] initWithFrame:CGRectMake(gap + totalSpacing, 0.f, size, size)];
        [btnPreviousMode setBackgroundColor:[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.f]];
        [btnPreviousMode setImage:[UIImage imageNamed:@"minu.png"] forState:UIControlStateNormal];
        [btnPreviousMode.imageView setOpaque:YES];
        btnPreviousMode.imageView.layer.cornerRadius = 10;
        btnPreviousMode.imageView.clipsToBounds = YES;
        [self addSubview:btnPreviousMode];
        
        btnStickyFingers = [[UIButton alloc] initWithFrame:CGRectMake(gap + totalSpacing * 2.f, 0.f, size, size)];
        [btnStickyFingers setBackgroundColor:[UIColor blackColor]];
        [btnStickyFingers.titleLabel setTextColor:[UIColor whiteColor]];
        [btnStickyFingers setTitle:@STICKY_FINGER_OFF_STR forState:UIControlStateNormal];
        btnStickyFingers.titleLabel.font = [UIFont fontWithName:@"Ariel" size:FONT_SIZE];
        [btnStickyFingers.layer setBorderColor:[UIColor whiteColor].CGColor];
        [btnStickyFingers.layer setBorderWidth:BORDER_WIDTH];
        btnStickyFingers.layer.cornerRadius = 10; // this value vary as per your desire
        btnStickyFingers.clipsToBounds = YES;
        [self addSubview:btnStickyFingers];
                
        btnOpenOptions = [[UIButton alloc] initWithFrame: CGRectMake(gap + totalSpacing * 3.f, 0.f, size, size)];
        [btnOpenOptions setImage:[UIImage imageNamed:@"ios_setting cog.png"] forState:UIControlStateNormal];
        [btnOpenOptions setBackgroundColor:self.backgroundColor];
        btnOpenOptions.imageView.layer.cornerRadius = 10;
        btnOpenOptions.imageView.clipsToBounds = YES;
        [self addSubview:btnOpenOptions];
        
        btnHelp = [[UIButton alloc] initWithFrame:CGRectMake(gap + totalSpacing * 4.f, 0.f, size, size)];
        [btnHelp setBackgroundImage:[UIImage imageNamed:@"qmark.png"] forState:UIControlStateNormal];
        [btnHelp setBackgroundColor:self.backgroundColor];
        btnHelp.imageView.layer.cornerRadius = 10;
        btnHelp.imageView.clipsToBounds = YES;
        btnHelp.layer.cornerRadius = 10;
        btnHelp.clipsToBounds = YES;
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
