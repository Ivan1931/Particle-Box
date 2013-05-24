//
//  Graviton.m
//  Particle Box
//
//  Created by Jonah Hooper on 2013/03/27.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "ForceNode.h"

@implementation ForceNode
#pragma mark - getters
@synthesize suction;
@synthesize position;
@synthesize strength;
#pragma mark - Default constructor
-(id) initWithStrength:(float)pstrength Suction:(float)psuction Position:(Vec2)xy
{
    self = [super init];
    if (self) {
        strength = pstrength;
        suction = psuction;
        position = xy;
        NSLog(@"x: %f y: %f", xy.x,xy.y);
        nothing = (Vec2){0.f,0.f};
        changeColor = (Color){rand() % 200 + 50, rand() % 200 + 50, rand() % 200 + 50};
        numNodes = 1;
        nodes = malloc(sizeof(Node));
        nodes[0] = (Node) {xy, 0};
    }
    return self;
}
-(void) influenceParticle:(Particle *)particle {
    
}
-(void) update{
    
}
-(void) moveNode:(Vec2)pposition {
    nodes[[self getIndexToClosestNode:pposition]].position = pposition;
    
}
-(void) deleteNode:(Vec2)pposition {
    int closest = [self getIndexToClosestNode:pposition];
    for (int i = closest; i < numNodes - 1; i++) {
        nodes[i] = nodes[i + 1];
    }
    numNodes--;
}
-(void) addNode:(Vec2)pposition {
    if (numNodes < MAX_NODES) {
        nodes = (Node*)realloc(nodes, (numNodes + 1) * sizeof(Node));
        nodes[numNodes] = (Node){pposition,numNodes - 1};
        numNodes++;
    }
}
-(int) getIndexToClosestNode:(Vec2)pposition {
    int ret = 0;
    float temp;
    float max = computeDistance(nodes[0].position, pposition);
    for (int i = 1 ; i < numNodes; i++) {
        temp = computeDistance(nodes[i].position, pposition);
        if (temp < max) {
            max = temp;
            ret = i;
        }
    }
    return ret;
}
-(int) getNumberNodes {
    return numNodes;
}
#pragma mark - Maths methods
+(float) Q_rsqrt:(float) number
{
    long i;
    float x2, y;
    const float threehalfs = 1.5F;
    
    x2 = number * 0.5F;
    y  = number;
    i  = * ( long * ) &y;                       // evil floating point bit level hacking
    i  = 0x5f3759df - ( i >> 1 );               // what the fuck?
    y  = * ( float * ) &i;
    y  = y * ( threehalfs - ( x2 * y * y ) );   // 1st iteration
    //      y  = y * ( threehalfs - ( x2 * y * y ) );   // 2nd iteration, this can be removed
    
    return y;
}
//Returns a two vector containing the x and y difference between two point
Vec2 computeXYDiff (Vec2 vec1, Vec2 vec2)
{
    return (Vec2){vec1.x - vec2.x, vec1.y - vec2.y};
}
//Evaluates to true with the following condition
//1. Both parameter vectors have equal values for x and y
bool isEqualVectors (Vec2 vec1, Vec2 vec2)
{
    return (vec1.x == vec2.x && vec1.y == vec2.y);
}
float computeDistance (Vec2 vec1, Vec2 vec2) {
    return sqrtf(powf(vec1.x - vec2.x,2.f) + powf(vec1.y - vec2.y, 2.f));
}
float computeGradient (Vec2 vecA, Vec2 vecB) {
    return (vecA.y - vecB.y)/(vecA.x - vecB.x);
}
@end
