//
//  Ribbon.m
//  Particle Box
//
//  Created by Jonah Hooper on 2013/05/24.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "Ribbon.h"

@implementation Ribbon
-(void) influenceParticle:(Particle *)particle {
    
}
-(void) ribbonEffect:(Particle *)particle toNode:(Node)node {
    Vec2 d = computeXYDiff(particle.position, node.position);
    //float distance =
}
@end
