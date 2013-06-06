//
//  Engine.m
//  Particle Box
//
//  Created by Jonah Hooper on 2013/03/25.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//


#import "Engine.h"

typedef unsigned char byte;

#define Clamp255(a) (a>255 ? 255 : a)

const float BUTTON_WIDTH_RATIO = 1.f / 10.f;

@implementation Engine

@synthesize smallMenu;
@synthesize menuButton;
@synthesize calc;
@synthesize renderLink;
@synthesize calculateLink;
@synthesize glview;

int startX = 0;
int startY = 0;

-(id) initWithSize:(CGRect)size andColor:(UIColor*)color {
    self = [super init];
    
    if (self)
    {        //
        width = size.size.width;
        height = size.size.height;
        colorSpace = CGColorSpaceCreateDeviceRGB();
        //Add the small menu button
        self.glview = [[GLView alloc] initWithFrame:size];
        
        float _size = size.size.width * BUTTON_WIDTH_RATIO;
        CGRect buttonFrame = CGRectMake(0.f,
                                        height - 2 * _size, _size, _size);
        menuButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        menuButton.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.f];
        menuButton.frame = buttonFrame;
        [menuButton setBackgroundImage:[UIImage imageNamed:@"Untitled.png"] forState:UIControlStateNormal];
        [menuButton setOpaque:YES];
        [menuButton addTarget:self action:@selector(menuButtonSelected) forControlEvents:UIControlEventTouchUpInside];
        
        [self.glview addSubview:menuButton];
        //Add the small menu and make it invisible for now
        smallMenu = [[SmallMenuView alloc] initWithFrame:CGRectMake(_size, height - 2 * _size, width, _size) forceMode:0];
        [self.glview addSubview:smallMenu];
        [smallMenu setHidden:YES];
        smallMenuOpen = NO;
        
        //
        [self setTargetsForSmallMenuBtns];
        
        //////////
        calculateLink = [CADisplayLink displayLinkWithTarget:calc selector:@selector(calculate:)];
        renderLink  =[CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
        [calculateLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        [renderLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        
        numAvailableModes = NUM_FMODE_TYPES;
       
    }
    return self;
}

-(void) setTargetsForSmallMenuBtns {
    //
    [smallMenu.btnStepUpMode addTarget:self action:@selector(cycleThroughFNodes:) forControlEvents:UIControlEventTouchUpInside];
    
    [smallMenu.btnScreenShot addTarget:self action:@selector(saveImage:) forControlEvents:UIControlEventTouchUpInside];
}
-(void) render:(CADisplayLink*) link  {
}


-(void)menuButtonSelected {
    [smallMenu setHidden:smallMenuOpen];
    smallMenuOpen = !smallMenuOpen;
}

-(void) moveForces:(CGPoint)xy {
    [calc moveGravity:xy];
}

-(IBAction) saveImage:(id) sender {
    NSLog(@"Image saved");
    [self pause];
    [self resume];
}

-(IBAction)cycleThroughFNodes:(id)sender  {
    NSLog(@"Mode increased");
    [self pause];
    int tmp = [calc currentNodeType];
    tmp = (tmp == numAvailableModes - 1) ? 0 : tmp + 1;
    [calc setForceNode:tmp];
    [self resume];
}

-(void) pause {
    [calculateLink setPaused:YES];
    [renderLink setPaused:YES];
}

-(void) resume {
    [calculateLink setPaused:NO];
    [renderLink setPaused:NO];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touch recieved");
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touch recieved");
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touch recieved");
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touch recieved");
}

@end
