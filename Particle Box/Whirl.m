//
//  Whirl.m
//  Particle Box
//
//  Created by Jonah Hooper on 2013/03/29.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "Whirl.h"
#import "Calculator.h"
#define SHORT_CHANGE 50000

@implementation Whirl
@synthesize clockwise;

-(id) initWithStrength:(float)pstrength Suction:(float)psuction Position:(Vec2)xy
             Clockwise:(BOOL)isClockwise screenDimesions:(Vec2)pdims{
    self = [super initWithStrength:pstrength Suction:psuction Position:xy dimesions:pdims];
    if (self) {
        radius_s = powf(xy.x, 2) + powf(xy.y, 2);
        radius = sqrtf(radius_s);
        omega = atan2f(xy.y, xy.x);
        clockwise = isClockwise;
        setRespawnBox (&dimesions,&spawnBoxUp, &spawnBoxLow,RESPAWN_AREA_S, 500);
    }
    return  self;
}

-(void) influenceParticle:(Particle *)particle {
    [particle resetVelocity];
    if(arc4random() % SHORT_CHANGE == 0)
        CHANGECOLOR(changeColor, 50);
    if ([particle outOfBounds:nothing :dimesions]) {
        if (arc4random() % RETURN_FREQUENCY != 0)
            return;
        else {
            [particle setColor:changeColor];
            setRespawnBox (&dimesions,&spawnBoxUp, &spawnBoxLow,RESPAWN_AREA_S,500);
        }
    }
    for (int i = 0; i < numNodes; i++)
        [self whirlEffect:particle to:nodes[i]];
    
}

-(void) whirlEffect:(Particle*)particle to:(Node)node {
    float disx = [particle position].x - node.position.x;
    float disy = [particle position].y - node.position.y;
    float r_s = powf(disx,2.f) + powf(disy,2.f);
    float r = sqrtf(r_s);
    float x = 0;
    float y = 0;
    if (r > strength * MAGIC_RATIO && arc4random() % ESCAPE_FREQUENCY != 0)
    {
        r -= suction;
        float theta;
        if (clockwise)
            theta = atan2f(disy, disx) + RADIAN;
        else
            theta = atan2f(disy, disx) - RADIAN;
        
        x = r * cosf(theta) ;
        y = r * sinf(theta) ;
        
        float dx = x - disx;
        float dy = y - disy;
        [particle addAcceleration:(Vec2) {dx, dy}];
    } else {
        float ranx = [Calculator randFloatBetween:spawnBoxUp.x and:spawnBoxLow.x];
        float rany = [Calculator randFloatBetween:spawnBoxUp.y and:spawnBoxLow.y];
        [particle setPosition:(Vec2){ranx, rany}];
        [particle bringToCurrent];
        [particle resetVelocity];
    }
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
