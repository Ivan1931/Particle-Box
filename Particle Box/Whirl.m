//
//  Whirl.m
//  Particle Box
//
//  Created by Jonah Hooper on 2013/03/29.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "Whirl.h"
#import "Calculator.h"

@implementation Whirl
@synthesize clockwise;
-(id) initWithStrength:(float)pstrength andSuction:(float)psuction andPosition:(Vec2)xy andClockwise:(BOOL)isClockwise{
    self = [super initWithStrength:pstrength Suction:psuction Position:xy];
    if (self) {
        radius_s = powf(xy.x, 2) + powf(xy.y, 2);
        radius = sqrtf(radius_s);
        omega = atan2f(xy.y, xy.x);
        clockwise = isClockwise;
    }
    return  self;
}
-(void) influenceParticle:(Particle *)particle {
    //r = a + bt
    //y = rsint
    //x = rsint
    //At center of 0...
    float disx = [particle position].x - position.x;
    float disy = [particle position].y - position.y;
    float r_s = powf(disx,2.f) + powf(disy,2.f);
    float r = sqrtf(r_s);
    float x = 0;
    float y = 0;
        if (r > strength * MAGIC_RATIO)
    {
        r -= suction;
        float theta;
        if (clockwise)
            theta = atan2f(disy, disx) + RADIAN;
        else
            theta = atan2f(disy, disx) - RADIAN;
        
        x = r * cosf(theta) ;//+ [Calculator randFloatBetween:-2.f and:2.f];
        y = r * sinf(theta) ;//+ [Calculator randFloatBetween:-2.f and:2.f];
        
        float dx = x - disx;
        float dy = y - disy;
        //dx = dx/r ;// * suction;
        //dy = dy/r ;//* suction;
        [particle addAcceleration:(Vec2) {dx, dy}];
    } else {
        float ranx = [Calculator randFloatBetween:NEGATIVE_MAGIC_PUSH and:MAGIC_PUSH] + position.x;
        float rany = [Calculator randFloatBetween:NEGATIVE_MAGIC_PUSH and:MAGIC_PUSH] + position.y;
        [particle setPosition:(Vec2){ranx, rany}];
        [particle bringToCurrent];
        [particle resetVelocity];
    }
    
    //NSLog(@"SAME!!!!!!!!!");
    //[particle addAcceleration:(Vec2) {x - disx, y - disy}];
    //[particle setPostion:(Vec2){x + position.x, y + position.y}];
    
}
-(void) setPosition:(Vec2)pos {
    [super setPosition:pos];
    radius_s = powf(pos.x, 2) + powf(pos.y, 2);
    radius = sqrtf(radius_s);
    omega = atan2f(pos.y, pos.x);
    currentSuction = suction;
}
-(void) update {
    currentSuction *= MAGIC_INCREMENTOR;
}

@end
