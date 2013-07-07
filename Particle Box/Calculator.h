//
//  Calculator.h
//  Particle Box
//
//  Created by Jonah Hooper on 2013/03/26.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Particle.h"
#import "Graviton.h"
#import "Whirl.h"
#import "Rose.h"
#import "Ribbon.h"
#import "BackShot.h"
#import "Suction.h"
#import "Spirals.h"
#import "Swirl.h"
#import "Repulsion.h"
#import "Crazy.h"

@interface Calculator : NSObject
{
    @private
    GLfloat* data;
    NSMutableArray *particles;
    int frameNumber;
    int bytesPerRow;
    Vec2 dims;
    Vec2 screenCenter;
    BOOL reset;
    BOOL tail;
    BOOL whirls;
    ForceNode *node;
    int currentNodeType;
    unsigned char** blank;
    uint numParticles;
    float velocityMultiplyer;
    BOOL stagnateMode;
    clock_t slowDownStart;
}
#pragma mark - Properties
@property uint numParticles;
@property float velocityMultiplyer;
@property BOOL stagnateMode;

@property (assign, nonatomic) GLfloat *data;
@property (nonatomic, strong) NSMutableArray *particles;
@property (nonatomic, strong) ForceNode *node;
@property int currentNodeType;
#pragma mark - Methods
-(void) calculate:(CADisplayLink*)link;
-(id) initWithData:(GLfloat*)pdata andDimesions:(Vec2)xy;
-(void) spawnParticles;
-(void) moveGravity:(CGPoint)xy;
-(void) resetParticles;

-(void) startStagnationTimer;

+(float) randFloatBetween:(float)low and:(float)high;

-(void) spawnNode;
-(void) spawnRose;
-(void) spawnGraviton;
-(void) spawnRibbon;
-(void) spawnWhirl;
-(void) spawnSuction;
-(void) spawnBackShot;
-(void) spawnSpiral;
-(void) spawnSwirl;
-(void) spawnRepulsion;

-(void) spawnExtraInternalNodes:(int) number;

-(void) setForceNode:(int) nodeNumber;

-(BOOL) hasStagnated;
@end
