//
//  PurchaseMenu.m
//  Particle Box
//
//  Created by Jonah Hooper on 2013/06/14.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "PurchaseMenu.h"

#define RESTORE_STR "Restore your purchase if it has already been made"
#define BUY_STR "Remove the adverts and double the number of particle effects available to you"

#define BORDER_WIDTH 2.f
@implementation PurchaseMenu

@synthesize labPurchase;
@synthesize labRestore;

@synthesize btnPurchase;
@synthesize btnRestore;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self.layer setBorderColor:[UIColor whiteColor].CGColor];
        [self.layer setBorderWidth:2.f];
        self.layer.cornerRadius = 10;
        
        float componentWidth = frame.size.width / 2 - 10.f;
        float componentHeight = frame.size.height / 2 - 10.f;
        labRestore = [[UILabel alloc]
                      initWithFrame:
                      CGRectMake(frame.size.width / 2 + 2.f, frame.size.height / 2, componentWidth, componentHeight)];
        [labRestore setFont:[UIFont fontWithName:@"Ariel" size:5.f]];
        [labRestore setBackgroundColor:self.backgroundColor];
        [labRestore setTextColor:[UIColor whiteColor]];
        [labRestore setNumberOfLines:5];
        [labRestore setText:@RESTORE_STR];
        [labRestore sizeToFit];
        
        labPurchase = [[UILabel alloc]
                       initWithFrame:
                       CGRectMake(3.f, frame.size.height / 2, componentWidth, componentHeight)];
        [labPurchase setFont:[UIFont fontWithName:@"Ariel" size:5.f]];
        [labPurchase setBackgroundColor:self.backgroundColor];
        [labPurchase setTextColor:[UIColor whiteColor]];
        [labPurchase setNumberOfLines:5];
        [labPurchase setText:@BUY_STR];
        [labPurchase sizeToFit];
        
        btnPurchase = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, componentWidth / 1.2, componentHeight / 1.2)];
        [btnPurchase setTitle:@"Buy" forState:UIControlStateNormal];
        [btnPurchase setBackgroundColor:[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.f]];
        [btnPurchase.titleLabel setTextColor:[UIColor whiteColor]];
        [btnPurchase.layer setBorderColor:[UIColor whiteColor].CGColor];
        [btnPurchase.layer setBorderWidth:BORDER_WIDTH];
        btnPurchase.layer.cornerRadius = 10; // this value vary as per your desire
        btnPurchase.clipsToBounds = YES;
        
        
        btnRestore = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width / 2, 5, componentWidth / 1.2, componentHeight / 1.2)];
        [btnRestore setTitle:@"Restore" forState:UIControlStateNormal];
        [btnRestore setBackgroundColor:[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.f]];
        [btnRestore.titleLabel setTextColor:[UIColor whiteColor]];
        [btnRestore.layer setBorderColor:[UIColor whiteColor].CGColor];
        [btnRestore.layer setBorderWidth:BORDER_WIDTH];
        btnRestore.layer.cornerRadius = 10; // this value vary as per your desire
        btnRestore.clipsToBounds = YES;
        
        
        [self addSubview:btnPurchase];
        [self addSubview:btnRestore];
        [self addSubview:labPurchase];
        [self addSubview:labRestore];
        
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,
                                  btnPurchase.frame.size.height +
                                  labPurchase.frame.size.height + 20.f)];
        
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
