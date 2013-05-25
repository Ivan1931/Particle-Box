//
//  Graviton.h
//  Particle Box
//
//  Created by Jonah Hooper on 2013/03/27.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Particle.h"
#define CHANGECOLOR(COL,MINCOL) { \
                                int rng = 255 - (MINCOL + 1);        \
                                (COL).r = rand() % rng + MINCOL; \
                                (COL).g = rand() % rng + MINCOL; \
                                (COL).b = rand() % rng + MINCOL; \
                            }
#define RESPAWN_AREA_S 20
#define SET_RESPAWN_BOX
@interface ForceNode : NSObject
{
    @protected
    
    float strength;
    float suction;
    
    Vec2 position;
    Vec2 nothing;
    Color changeColor;
    
    Node* nodes;
    int numNodes;
    
    Vec2 dimesions;
    
    Vec2 spawnBoxUp;
    Vec2 spawnBoxLow;
}
@property (nonatomic) Vec2 position;

@property (nonatomic) float strength;

@property (nonatomic) float suction;

-(id) initWithStrength:(float) pstrength Suction:(float)psuction Position:(Vec2)xy dimesions:(Vec2)pdims;

-(void) influenceParticle:(Particle*)particle;
-(void) update;

-(int) getNumberNodes;
-(void) addNode:(Vec2)position;
-(void) deleteNode:(Vec2)position;
-(void) moveNode:(Vec2) position;

+(float) Q_rsqrt:(float) number;

Vec2 computeXYDiff (Vec2 vec1, Vec2 vec2);
float computeDistance (Vec2 vec1, Vec2 vec2);
float computeGradient (Vec2 vecA, Vec2 vecB);
bool isEqualVectors (Vec2 vec1, Vec2 vec2);
void setRespawnBox (Vec2* area, Vec2* topBox, Vec2* bottomBox, size_t boxSize);

@end
