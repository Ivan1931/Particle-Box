//
//  Calculator.m
//  Particle Box
//
//  Created by Jonah Hooper on 2013/03/26.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "Calculator.h"

#define swap_(a, b) do{ __typeof__(a) tmp;  tmp = a; a = b; b = tmp; }while(0)
@implementation Calculator


@synthesize currentNodeType;
@synthesize data;
@synthesize particles;
@synthesize node;
@synthesize numParticles;
@synthesize velocityMultiplyer;
@synthesize stagnateMode;

-(id) initWithData:(GLfloat *)pdata andDimesions:(Vec2)xy {
    self = [super init];
    if (self) {
        dims = xy;
        data = pdata;
        particles = [[NSMutableArray alloc] init];
        frameNumber = 0;
        reset = false;
        tail = false;
        whirls = false;
        currentNodeType = 0;
        screenCenter = VEC2(dims.x / 2.f, dims.y / 2.f);
        [self spawnParticles];
        numParticles = MAX_PARTICLES;
        stagnateMode = NO;
    }
    return self;
}

-(void) calculate:(CADisplayLink *)link {
    //NSLog(@"Calculating");
    for (int p = 0; p < numParticles; p++) {
        Particle* local = [particles objectAtIndex:p];
        if (node != nil) {
            [node influenceParticle:local];
            if (stagnateMode && node.getNumberNodes == 0) {
                clock_t timeDifference = clock() - slowDownStart;
                float finalSpeed = velocityMultiplyer * (1.f - (float)timeDifference / (float)MAX_SLOW_DOWN_TIME) / 2.f;
                finalSpeed = finalSpeed < 0.f ? 0.f : finalSpeed;
                [local moveWithVelocityMultiplyer:finalSpeed];
            } else {
                [local moveWithVelocityMultiplyer:velocityMultiplyer];

            }
        }
        [self renderParticle:local];
        if (reset){
            if(local.position.x <= 0) { 
                local.position = (Vec2){dims.x, local.position.y};
                [local resetVelocity];
            }
            else if (local.position.x >= dims.x) {
                local.position = (Vec2) {0.f,local.position.y};
                [local resetVelocity];
            }
            if (local.position.y <= 0) {
                local.position = (Vec2) {local.position.x, dims.y};
                [local resetVelocity];
            } else if (local.position.y >= dims.y) {
                local.position = (Vec2){local.position.x, 0.f};
                [local resetVelocity];
            }
        }
        
    }
    if([node getNumberNodes] > 0)
        [node update];
}

#pragma mark - render
-(void) renderParticle:(Particle*)particle{
    float normCurrX = (particle.position.x - screenCenter.x) / screenCenter.x;
    float normCurrY = -(particle.position.y - screenCenter.y) / screenCenter.y;
    float normPrevX = (particle.previousPosition.x - screenCenter.x) / screenCenter.x;
    float normPrevY = -(particle.previousPosition.y - screenCenter.y) / screenCenter.y;
    data[particle.getDataIndex] = normPrevX;
    data[particle.getDataIndex + 1] = normPrevY;
    data[particle.getDataIndex + 2] = normCurrX;
    data[particle.getDataIndex + 3] = normCurrY;
}


void swap(int *a,int *b){
    int *temp = b;
    b = a;
    a = temp;
}

-(void) spawnParticles {
    for (int p = 0; p < MAX_PARTICLES; p++){
        Vec2 pos = {
            .x = [Calculator randFloatBetween:0.f and:dims.x],
            .y = [Calculator randFloatBetween:0.f and:dims.y]
        };
        float w = [Calculator randFloatBetween:200 and:255];
        Color col = {
          w,w,w
        };
        Particle *part = [[Particle alloc] initWith:pos Color:col atDataIndex:p * POINTS_PER_PARTICLE];
        [particles addObject:part];
    }
    [self setForceNode:0];
}

-(void) resetParticles {
    //NSLog(@"Reset");
    for (int i = 0; i < numParticles; i++) {
        Particle* local = [particles objectAtIndex:i];
        [local respawnInBounds:VEC2(0.f,0.f) :dims];
        [local bringToCurrent];
        [local resetVelocity];
    }
}
-(void) spawnBackShot {
    node = [[BackShot alloc] initWithStrength:10.f Suction:3.f Position:VEC2(dims.x / 2, dims.y / 2) dimesions:dims];
}

-(void) spawnRose {
    node = [[Rose alloc] initWithStrength:2.f Suction:2.f Position:VEC2 (dims.x / 2, dims.y / 2) dimesions:dims];
}

-(void) spawnGraviton {
    node = [[Graviton alloc] initWithStrength:15.f Suction:3.f Position:(Vec2){dims.x / 6, dims.y / 6} dimesions:dims];
}

-(void) spawnWhirl {
    node = [[Whirl alloc] initWithStrength:15.f Suction:5.f Position:(Vec2){dims.x / 6, dims.y / 6} Clockwise:TRUE screenDimesions:dims];
    
}

-(void) spawnRibbon {
    node = [[Ribbon alloc] initWithStrength:10.f Suction:0.f Position:VEC2(dims.x/4, dims.y / 4 ) dimesions:dims];
}

-(void) spawnNode {
    node = [[ForceNode alloc] initWithStrength:2.f Suction:1.f Position:VEC2(dims.x / 2, dims.y / 2) dimesions:dims];
}


-(void) spawnSpiral {
    node = [[Spirals alloc] initWithStrength:20.f Suction:2.f Position:VEC2(dims.x / 2, dims.y / 2) dimesions:dims];
}

-(void) spawnSwirl {
    node = [[Swirl alloc] initWithStrength:10.f Suction:2.f Position:VEC2(dims.x / 2, dims.y / 2) dimesions:dims];
}

-(void) spawnRepulsion {
    node = [[Repulsion alloc] initWithStrength:10.f Suction:3.f Position:VEC2(dims.x / 2, dims.y / 2) dimesions:dims];
}

-(void) spawnSuction {
    node = [[Suction alloc] initWithStrength:3.f Suction:10.f Position:VEC2(dims.x/ 2.f, dims.y / 2.f) dimesions:dims];
}

-(void) spawnCrazy {
    node = [[Crazy alloc] initWithStrength:3.f Suction:1.f Position:VEC2(0, 0) dimesions:dims];
}
-(void) spawnExtraInternalNodes:(int)number {
    int screen_divisor = number + 1;
    for (int i = 0; i < number; i++) {
        [node addNode:VEC2((i + 2) * dims.x / screen_divisor , (i + 2) * dims.y / screen_divisor)];
    }
}

-(void) setForceNode:(int)nodeNumber {
    currentNodeType = nodeNumber;
    NodeList nodeList = [node getNodeList];
    [node deleteNodes];
    switch (nodeNumber) {
        case BACK_SHOT:
            [self spawnBackShot];
            break;
        case RIBBON:
            [self spawnRibbon];
            break;
        case GRAVITON:
            [self spawnGraviton];
            break;
        case SPIRALS:
            [self spawnSpiral];
            break;
        case REPULSION:
            [self spawnRepulsion];
            break;
        case SWIRL:
            [self spawnSwirl];
            break;
        case SUCTION:
            [self spawnSuction];
            break;
        case WHIRL:
            [self spawnWhirl];
            break;
        case ROSE:
            [self spawnRose];
            break;
        case CRAZY:
            [self spawnCrazy];
            break;
        default:
            [self spawnNode];
            break;
    }
    [node addNodeList:nodeList];

}
#pragma mark - move gravity

-(void) moveGravity:(CGPoint)xy {
    [node moveNode:(Vec2){xy.x, xy.y}];
}

+(float) randFloatBetween:(float)low and:(float)high {
    float diff = high - low;
    return (((float) rand() / RAND_MAX) * diff) + low;
}

-(void) startStagnationTimer {
    slowDownStart = clock();
}

-(BOOL) hasStagnated {
    return clock() - slowDownStart > MAX_SLOW_DOWN_TIME;
}

@end
