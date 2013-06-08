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
-(id) initWithStrength:(float)pstrength Suction:(float)psuction Position:(Vec2)xy dimesions:(Vec2)pdims{
    self = [super init];
    if (self) {
        
        strength = pstrength;
        suction = psuction;
        
        position = xy;
        
        nothing = (Vec2){0.f,0.f};
        
        changeColor = (Color){rand() % 200 + 50, rand() % 200 + 50, rand() % 200 + 50};
        
        /*numNodes = 1;
        nodes = malloc(sizeof(Node));
        nodes[0].position = xy;
        nodes[0].ID =  0;
        nodes[0].prevPos = position;*/
        
        dimesions = pdims;
        
        colorChngGap = 0;
        
        nodeChangeGap = 0;
        
        setRespawnBox(&dimesions, &spawnBoxUp, &spawnBoxLow, RESPAWN_AREA_S, 500);
    }
    return self;
}

-(BOOL) influenceParticle:(Particle *)particle {
    if (numNodes == 0) return NO;
    [self validateParticle:particle];
    return YES;
}

-(void) brownianEffect:(Particle *) particle {
    [particle addAcceleration:VEC2(0.1f * (RANFLOAT - RANFLOAT), 0.1f * (RANFLOAT - RANFLOAT))];
}

-(void) update{
    
}

//This method is intended to apply all particle color effects and particle modifications
-(void) validateParticle:(Particle *)particle {
    if (numNodes > 0) {
        if (particle.nodeID >= numNodes) {
            particle.nodeID = arc4random() % numNodes;
        }
    }
}

-(void) respawnParticleInRandomBox:(Particle*) particle {
    [particle setPosition:(Vec2){ RAND_BETWEEN((int)spawnBoxUp.x,(int)spawnBoxLow.x),
                                        RAND_BETWEEN((int)spawnBoxUp.y, (int)spawnBoxLow.y)}];
    [particle bringToCurrent];
}

//Implementation of the node system ///////////////////////////////////////

-(void) iterateNodeChange:(Particle *) particle :(int) iterationLimit {
    if (nodeChangeGap < iterationLimit) {
        nodeChangeGap++;
    } else {
        [self changeParticleNode:particle];
        nodeChangeGap = 0;
    }
}

-(void) particleColorToNode:(Particle*)particle {
    if (!([particle nodeID] >= numNodes))
        [particle setColor:nodes[particle.nodeID].nodeColor];
}

-(void) changeParticleNode:(Particle*) particle {
    [particle setNodeID:arc4random() % numNodes];
}

-(void) moveNode:(Vec2)pposition {
    int closestNode = [self getIndexToClosestNode:pposition];
   // NSLog(@"Node %d moved",closestNode);
    nodes[closestNode].prevPos = nodes[closestNode].position;
    nodes[closestNode].position = pposition;
    
}


-(void) deleteNode:(Vec2)pposition {
    [self deleteNodeAtIndex:[self getIndexToClosestNode:pposition]];
}

-(void) deleteNodeAtIndex:(int)index {
    for (int i = index; i < numNodes - 1; i++) {
        nodes[i] = nodes[i + 1];
        nodes[i].ID = i + 1;
    }
    numNodes--;
}
-(void) addNode:(Vec2)pposition {
    if (numNodes < MAX_NODES) {
        if (numNodes == 0)
            nodes = (Node*)malloc(sizeof(Node));
        else
            nodes = (Node*)realloc(nodes, (numNodes + 1) * sizeof(Node));
        nodes[numNodes].position = pposition;
        nodes[numNodes].ID = numNodes;
        nodes[numNodes].prevPos = pposition;
        numNodes++;
    }
}

-(void) deleteNodes {
    numNodes = 0;
    free(nodes);
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

-(Vec2*) getNodePositions {
    Vec2* ret = (Vec2*) malloc(sizeof(Vec2) * numNodes);
    for (int i = 0 ; i < numNodes; i++){
        ret[i] = nodes[i].position;
    }
    return ret;
}

-(NodeList) getNodeList {
    NodeList ret;
    Node* tmp = (Node*) malloc(sizeof(Node) * numNodes * 2);
    ret.len = numNodes;
    for (int i = 0; i < numNodes; i++) {
        tmp[i] = nodes[i];
    }
    ret.nodes = tmp;
    return ret;
}

-(void) iterateColorNodeChangeValue:(Node*)node :(int) iterationLimit {
    if (colorChngGap < iterationLimit) {
        colorChngGap++;
    } else {
        colorChngGap = 0;
        CHANGECOLOR(node->nodeColor, MIN_RGB_VAL);
    }
}

-(void) addNodeList:(NodeList)list {
    //free(nodes);
    numNodes = list.len;
    nodes = (Node*) malloc(sizeof(Node) * list.len);
    for (int i = 0; i < list.len; i++) {
        nodes[i] = list.nodes[i];
    }
}
/////////////////////////////////////////////////////////////////////

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
Vec2 computeXYDiff (Vec2 vec1, Vec2 vec2){
    return (Vec2){vec1.x - vec2.x, vec1.y - vec2.y};
    
}

Vec2 computeMidPoint (Vec2 vec1, Vec2 vec2) {
    return (Vec2){(vec1.x + vec2.x)/2, (vec1.y + vec2.y)/2};
}

//Evaluates to true with the following condition
//1. Both parameter vectors have equal values for x and y
bool isEqualVectors (Vec2 vec1, Vec2 vec2){
    return (vec1.x == vec2.x && vec1.y == vec2.y);
}

float computeDistance (Vec2 vec1, Vec2 vec2) {
    return sqrtf(powf(vec1.x - vec2.x,2.f) + powf(vec1.y - vec2.y, 2.f));
}

float computeGradient (Vec2 vecA, Vec2 vecB) {
    if (fabsf(vecA.x - vecB.x) > 0)
        return (vecA.y - vecB.y)/(vecA.x - vecB.x);
    else
        return 0.f;
}

void setRespawnBox (Vec2* area, Vec2* topBox, Vec2* bottomBox, size_t boxSize, int outerBounds){
    topBox->x =  -outerBounds + (arc4random() % (int)area->x + outerBounds);
    topBox->y =  -outerBounds + (arc4random() % (int)area->y + outerBounds);
    bottomBox->x = topBox->x + arc4random() % boxSize;
    bottomBox->y = topBox->y + arc4random() % boxSize;
}

@end
