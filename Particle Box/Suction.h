//
//  Suction.h
//  Particle Box
//
//  Created by Jonah Hooper on 2013/05/31.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "ForceNode.h"

@interface Suction : ForceNode {
    Vec2 midPnts[5];
    float nodeDistances[5];
}

-(void) influenceParticle:(Particle *)particle;

-(void) moveNode:(Vec2) pposition;

-(void) addNode:(Vec2)pposition;

@end
