//
//  Calculator.m
//  Particle Box
//
//  Created by Jonah Hooper on 2013/03/26.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "Calculator.h"

@implementation Calculator

@synthesize data;
@synthesize particles;
@synthesize forces;
-(id) initWithData:(unsigned char *)pdata andDimesions:(Vec2)xy {
    self = [super init];
    if (self) {
        dims = xy;
        bytesPerRow = (xy.x * BITSPERCOMPONENT * BYTESPERPIXEL + 7) / 8;
        data = pdata;
        particles = [[NSMutableArray alloc] init];
        forces = [[NSMutableArray alloc] init];
        frameNumber = 0;
        reset = false;
        tail = true;
        whirls = false;
        [self spawn1000Particles];
    }
    return self;
}
-(void) calculate:(CADisplayLink *)link {
    //NSLog(@"Calculating");
    
    [self clearRaster];
    for (int p = 0; p < particles.count; p++) {
        Particle* local = [particles objectAtIndex:p];
        for (int f = 0; f < forces.count; f++) {
            [(ForceNode*)[forces objectAtIndex:f] influenceParticle:local];
        }
        [local move];
        if (whirls)
            [local resetVelocity];
        [self renderParticle:local];
        if (reset){
            if(local.position.x <= 0)
                local.position = (Vec2){dims.x, local.position.y};
            else if (local.position.x >= dims.x)
                local.position = (Vec2) {0.f,local.position.y};
            if (local.position.y <= 0)
                local.position = (Vec2) {local.position.x, dims.y};
            else if (local.position.y >= dims.y)
                local.position = (Vec2){local.position.x, 0.f};
        }
        
    }
    for (int f = 0 ; f < forces.count; f++)
    {
        [(ForceNode*)[forces objectAtIndex:f] update];
    }
    
}
-(void) clearRaster {
    int maxBytes = (bytesPerRow * (dims.y - 1)) + (dims.x - 1) * BYTESPERPIXEL;
    if (tail) {
        for (int i = 0; i < maxBytes; i+=4) {
            //if (data[i] > 3) data[i]-=3;
            for (int j = i + 0; j < i + 3; j++){
                if (data[j] > 5)
                    data[j]-=5;
            }
            if (data[maxBytes + 2] > 3)
                    data[maxBytes + 2] -= 3;
        }
    } else {
        for (int i = 0; i < maxBytes; i++) {
            data[i] = 0;
        }
    }
    //NSLog(@"Max Bytes %d",maxBytes);
}
#pragma mark - render
-(void) renderParticle:(Particle*)particle{
    //int mult = bytesPerRow / dims.x;
    [self renderPixelatX:particle.position.x andY:particle.position.y withColor:particle.color];
    //NSLog(@"%f %f %f %f",particle.postion.x, particle.postion.y, [particle getPrevious].x, [particle getPrevious].y);
    [self LineBresenhamwithX1:particle.position.x andX2:[particle previousPosition].x
                    andY1:particle.position.y andY2:[particle previousPosition].y andColor:particle.color];
}
-(void) renderPixel:(Vec2)pos andColor:(Color)col {
    if (pos.x >= 0 && pos.x < dims.x - 6){
        if (pos.y >= 0 && pos.y < dims.y - 6){
            int byteIndex = 4 * (int) (pos.x) + bytesPerRow * (int)(pos.y);
            data[byteIndex] = col.r;
            data[byteIndex + 1] = col.g;
            data[byteIndex + 2] = col.b;
            
        }
    }

}
-(void) renderPixelatX:(int)x andY:(int)y withColor:(Color)col {
    if (x >= 0 && x < dims.x - 6){
        if (y >= 0 && y < dims.y - 6){
            int byteIndex = 4 * x + bytesPerRow * y;
            data[byteIndex] = col.r;
            data[byteIndex + 1] = col.g;
            data[byteIndex + 2] = col.b;
            /*
             data[byteIndex + bytesPerRow] = col.r;
             data[byteIndex + bytesPerRow + 1] = col.g;
             data[byteIndex + bytesPerRow + 2] = col.b;
             
             data[byteIndex + 4] = col.r;
             data[byteIndex + 5] = col.g;
             data[byteIndex + 6] = col.b;
             
             data[byteIndex + bytesPerRow + 4] = col.r;
             data[byteIndex + bytesPerRow + 5] = col.g;
             data[byteIndex + bytesPerRow + 6] = col.b;
             */
        }
    }
}
void swap(int *a,int *b){
    int *temp = b;
    b = a;
    a = temp;
}
-(void) LineBresenhamwithX1:(int)x andX2:(int)x2 andY1:(int)y andY2:(int)y2 andColor:(Color)col
{
    int shortLen = y2-y;
    int longLen = x2-x;
    bool yLonger;
    //if ((shortLen ^ (shortLen >> 31) – shortLen >> 31) > (longLen ^ (longLen >> 31)) – (longLen >> 31)))
    if (((shortLen ^(shortLen >> 31)) - (shortLen >> 31)) > ((longLen ^ (longLen >> 31)) - (longLen >> 31))) 
   {
        shortLen ^= longLen;
        longLen ^= shortLen;
        shortLen ^= longLen;
       
        yLonger = true;
    }
    else
    {
        yLonger = false;
    }
    
    int inc = longLen < 0 ? -1 : 1;
    
    float multDiff = longLen == 0 ? shortLen : shortLen / longLen;
    int i = 0;
    if (yLonger)
    {
        for (i = 0; i != longLen; i += inc)
        {
            [self renderPixelatX:x + i * multDiff andY: y + i withColor:col];
        }
    }
    else
    {
        for (i = 0; i != longLen; i += inc)
        {
            [self renderPixelatX:x + i andY: y + i * multDiff withColor:col];
        }
    }
}

-(void) spawn1000Particles {
    for (int p = 0; p < 3000; p++){
        
        Vec2 pos = {
            .x = [Calculator randFloatBetween:0.f and:dims.x],
            .y = [Calculator randFloatBetween:0.f and:dims.y]
        };
        float w = [Calculator randFloatBetween:200 and:255];
        Color col = {
          w,w,w
        };
        Particle *part = [[Particle alloc] initWith:pos andColor:col];
        [particles addObject:part];
    }
    NSLog(@"Dimsx and y: %f, %f",dims.x / 2,dims.y / 2);
    Graviton *force = [[Graviton alloc] initWithStrength:10.0f andSuction:1.7f andPosition:(Vec2){ .x = dims.x / 2, .y = dims.y/4}];
    //Whirl *force1 = [[Whirl alloc] initWithStrength:10.0f andSuction:1.0f andPosition:(Vec2){ .x = dims.x / 2, .y = dims.y/4 * 3} andClockwise:false];
    
    /*Graviton *force = [[Graviton alloc] initWithStrength:10.0f andSuction:1.8f andPosition:(Vec2){ .x = dims.x / 2, .y = dims.y/4}];
    Graviton *force1 = [[Graviton alloc] initWithStrength:10.0f andSuction:1.3f andPosition:(Vec2){ .x = dims.x / 2, .y = dims.y/4 * 3}];*/
    [forces addObject:force];
    //[forces addObject:force1];
    
}
#pragma mark - move gravity
-(void) moveGravity:(CGPoint)xy {
    [[forces objectAtIndex:0] setPosition:(Vec2){xy.x,xy.y}];
    
}
+(float) randFloatBetween:(float)low and:(float)high
{
    float diff = high - low;
    return (((float) rand() / RAND_MAX) * diff) + low;
}
@end
