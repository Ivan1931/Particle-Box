//
//  Whirl.m
//  Particle Box
//
//  Created by Jonah Hooper on 2013/03/29.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "Whirl.h"
#define RADIAN 0.01745329251
@implementation Whirl
-(id) initWithStrength:(float)pstrength andSuction:(float)psuction andPosition:(Vec2)xy {
    self = [super initWithStrength:pstrength andSuction:psuction andPosition:xy];
    if (self) {
        radius_s = powf(xy.x, 2) + powf(xy.y, 2);
        radius = sqrtf(radius_s);
        omega = atan2f(xy.y, xy.x);
    }
    return  self;
}
-(void) influenceParticle:(Particle *)particle {
    //r = a + bt
    //y = rsint
    //x = rsint
    //At center of 0...
    float disx = [particle postion].x - position.x;
    float disy = [particle postion].y - position.y;
    
    float r_s = powf(disx, 2.f) + powf(disy, 2.f);
    float r = r_s * [ForceNode Q_rsqrt:r_s];
    float theta = atan2f(disx, disy);
    float alpha = M_PI - theta + omega;
    
    float dr_s = r_s + radius_s - (2 * radius * r * cosf(alpha));
    
    float dr = dr_s * [ForceNode Q_rsqrt:dr_s];
    
    float dangle = asinf((r * sinhf(alpha))/dr) + omega;
    
    float x = dr * cosf(dangle);
    float y = dr * sinf(dangle);
    NSLog(@"\n\n\n");
    NSLog (@"Particle position: %f %f",particle.postion.x, particle.postion.y);
    NSLog(@"Distances: %f %f",disx,disy);
    NSLog(@"DR :%f, ",dr);
    NSLog(@"X: %f, Y: %f",x,y);
    NSLog(@"DLs: %f",dangle);
    NSLog(@"theta: %f",theta/RADIAN);
    if (x == particle.postion.x && y == particle.postion.y)
        NSLog(@"SAME!!!!!!!!!");
    [particle setPostion:(Vec2){x, y}];
        
}
-(void) setPosition:(Vec2)pos {
    [super setPosition:pos];
    radius_s = powf(pos.x, 2) + powf(pos.y, 2);
    radius = sqrtf(radius_s);
    omega = atan2f(pos.y, pos.x);
}


@end
