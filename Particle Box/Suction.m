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

-(id) initWithStrength:(float)pstrength Suction:(float)psuction Position:(Vec2)xy dimesions:(Vec2)pdims {
    self = [super initWithStrength:pstrength Suction:psuction Position:xy dimesions:pdims];
    if (self) {
        [self computeMidPnts];
    }
    return self;
}

-(BOOL) influenceParticle:(Particle *)particle {
    if (![super influenceParticle:particle]) return NO;
    if (numNodes == 1) {
        [self singleNodeSuction:particle];
        return YES;
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
    return YES;
}

-(void) singleNodeSuction:(Particle *) particle {
    Vec2 d = computeXYDiff(particle.position, nodes[0].position);
    float distance = computeDistance(particle.position, nodes[0].position);
    if (distance < strength * 2) {
        [particle setPosition:VEC2(RANFLOAT * dimesions.x, RANFLOAT * dimesions.y)];
        [particle bringToCurrent];
        [particle resetVelocity];
    } else {
        Vec2 a = VEC2(-2.f * sinf(d.x / distance), -2.f * sinf(d.y /distance));
        [particle setVelocity:a];
    }
}

-(void) suctionBetween:(Node) node :(Node) node0 withParticle:(Particle *) particle {
    Vec2 midpnt = midPnts[node.ID];
    Vec2 d = computeXYDiff(particle.position, midpnt);
    
    float nodeDistance  = nodeDistances[node.ID];
    float particleDistance = computeDistance(particle.position, midpnt);
    if (particleDistance < strength * 2 || [particle outOfBounds:nothing :dimesions]) {
        do {
            [particle setPosition:VEC2(RANFLOAT * dimesions.x, RANFLOAT * dimesions.y)];
            [particle bringToCurrent];
            [particle setColor:node.nodeColor];
            [particle resetVelocity];
        } while (computeDistance(particle.position, midpnt) < strength * 2);
    } else if (particleDistance < nodeDistance && nodeDistance != 0) {
        
        float strengthRatio = nodeDistance / nodeDistance;
        [particle setVelocity:VEC2(-(strengthRatio * strength * d.x) / particleDistance
                                , -(strengthRatio * strength * d.y) / particleDistance)];
        
    } else {
        [self brownianEffect:particle];
        Vec2 a = VEC2(-sinf(d.x / nodeDistance), -sinf(d.y /nodeDistance));
        a.x *= 0.1f;
        a.y *= 0.1f;
        [particle addAcceleration:a];
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

-(void) addNodeList:(NodeList)list {
    [super addNodeList:list];
    [self computeMidPnts];
}

-(BOOL) requiresFadeEffect {
    return YES;
}
@end
