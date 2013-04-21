//
//  Rose.m
//  Particle Box
//
//  Created by Jonah Hooper on 2013/04/19.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "Rose.h"

@implementation Rose
@synthesize firePosition;
-(id) initWithStrength:(float)pstrength andSuction:(float)psuction andPosition:(Vec2)xy andFirePosition:(Vec2)fp andDimensions:(Vec2)dims{
    self = [super initWithStrength:pstrength andSuction:psuction andPosition:xy];
    if (self) {
        firePosition = fp;
    }
    return self;
}
-(void) influenceParticle:(Particle *)particle {
    if (particle.position.x == position.x && particle.position.y == position.y)
    {
        float sr = computeDistance(position, particle.position) * strength;
        Vec2 dixy = computeXYDiff(position, particle.position);
        [particle setVelocity:(Vec2){sr * dixy.x, sr * dixy.y}];
    } else if (particle.position.x > 0 && particle.position.y > 0)
    {
        if (particle.position.x < dims.x && particle.position.y < dims.y)
        {
            [particle setPosition:position];
            [particle bringToCurrent];
            [particle resetVelocity];
        }
    }
    
}
@end
