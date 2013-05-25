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

-(id) initWithStrength:(float)pstrength suction:(float)psuction position:(Vec2)xy firePosition:(Vec2)fp dimensions:(Vec2)pdims{
    self = [super initWithStrength:pstrength Suction:psuction Position:xy dimesions:pdims];
    if (self) {
        firePosition = fp;
        dims = pdims;
        randomValueTable = malloc(sizeof(float) * RAND_TABLE_SIZE);
        for (int i = 0; i < RAND_TABLE_SIZE; i++)
            randomValueTable[i] = (float)rand() / (float)RAND_MAX;
    }
    return self;
}
-(void) influenceParticle:(Particle *)particle {
    if (particle.position.x == position.x && particle.position.y == position.y)
    {
        float sr = strength / computeDistance(firePosition, particle.position);
        float ranoffsetX = randomValueTable[rand() % RAND_TABLE_SIZE];
        float ranoffsetY = randomValueTable[rand() % RAND_TABLE_SIZE];
        Vec2 dixy = computeXYDiff(firePosition, particle.position);
        [particle setVelocity:(Vec2){sr * dixy.x * ranoffsetX, sr * dixy.y * ranoffsetY}];
        //NSLog(@"HERE");
    } else if (particle.position.x < 0 || particle.position.y < 0
          || particle.position.x > dims.x || particle.position.y > dims.y)
    {
        [self bringToCenter:particle];
        
    } else if (isEqualVectors(particle.velocity,nothing))
    {
        [self bringToCenter:particle];
        
    }
    
}
-(void) bringToCenter:(Particle*) particle {
    [particle setPosition:position];
    [particle bringToCurrent];
    [particle resetVelocity];
}
@end
