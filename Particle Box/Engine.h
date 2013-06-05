//
//  Engine.h
//  Particle Box
//
//  Created by Jonah Hooper on 2013/03/25.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "RenderView.h"
#include "Calculator.h"
#include "Timer.h"
#include "SmallMenuView.h"

extern const float BUTTON_WIDTH_RATIO;

@interface Engine : UIView
{
    @public
    Calculator *calc;
    CADisplayLink *renderLink;
    CADisplayLink *calculateLink;
    @private
    
    UIButton *menuButton;
    UIImage *image;
    SmallMenuView *smallMenu;
    
    unsigned char* data;
    NSUInteger len;
    
    CGColorSpaceRef colorSpace;
    
    uint width;
    uint height;
    
    BOOL smallMenuOpen;
    
    int numAvailableModes;
    
}

@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) SmallMenuView *smallMenu;

@property (nonatomic,retain) Calculator *calc;

@property (nonatomic,retain) CADisplayLink *renderLink;
@property (nonatomic,retain) CADisplayLink *calculateLink;

-(id) initWithSize:(CGRect)size andColor:(UIColor*)color;
-(void) updateImage;
-(void) render:(CADisplayLink*) link ;
-(void) clearRaster:(CADisplayLink*) link;
-(void) moveForces:(CGPoint)xy;

-(void) menuButtonSelected;
@end
