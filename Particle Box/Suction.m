//
//  Suction.m
//  Particle Box
//
//  Created by Jonah Hooper on 2013/05/31.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "Suction.h"

const float MIN_DISTANCE = 3.f;

const int COL_CHNG_FREQ = 500000;

const int LOW_COLOR_THRESH = 50;

@implementation Suction

-(void) influenceParticle:(Particle *)particle {
    
    if (numNodes < 2) {
        [super influenceParticle:particle];
        return;
    }
    int nextNode = 0;
    for (int i = 0; i < numNodes; i++) {
        nextNode = (i == numNodes - 1) ? 0 : i;
        [self suctionBetween:nodes[i] :nodes[nextNode] withParticle:particle];
        colorChngGap++;
        if (colorChngGap >= COL_CHNG_FREQ) {
            colorChngGap = 0;
            CHANGECOLOR(nodes[i].nodeColor,LOW_COLOR_THRESH);
        }
    }
}

-(void) suctionBetween:(Node) node :(Node) node0 withParticle:(Particle *) particle {
    
    Vec2 midpnt = midPnts[node.ID];
    Vec2 d = computeXYDiff(particle.position, midpnt);
    
    float nodeDistance  = nodeDistances[node.ID];
    float particleDistance = computeDistance(particle.position, midpnt);
    if (particleDistance < strength || [particle outOfBounds:nothing :dimesions ]) {
        
        [particle setPosition:VEC2(RANFLOAT * dimesions.x, RANFLOAT * dimesions.y)];
        [particle bringToCurrent];
        [particle setColor:node.nodeColor];
        [particle resetVelocity];
        
    } else if (particleDistance < nodeDistance && particleDistance != 0 && nodeDistance != 0) {
        
        float strengthRatio = nodeDistance / nodeDistance;
        [particle setVelocity:VEC2(-(strengthRatio * strength * d.x) / (particleDistance)
                                , -(strengthRatio * strength * d.y) / (particleDistance))];
        
    } else {
        
        [super influenceParticle:particle];
        
    }
}

-(void) moveNode:(Vec2)pposition {
    [super moveNode:pposition];
    [self computeMidPnts];
}

-(void) computeMidPnts {
    int nextNode;
    for (int i = 0 ; i < numNodes; i++) {
        nextNode = (i != numNodes - 1) ? i + 1 : 0;
        midPnts[i] = computeMidPoint(nodes[i].position, nodes[nextNode].position);
        nodeDistances[i] = computeDistance(nodes[i].position, midPnts[i]);
    }
}

-(void) addNode:(Vec2)pposition {
    [super addNode:pposition];
    [self computeMidPnts];
}
@end
