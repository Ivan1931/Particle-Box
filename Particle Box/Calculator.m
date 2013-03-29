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
        [self renderParticle:local];
    }
}
-(void) clearRaster {
    int maxBytes = (bytesPerRow * (dims.y - 1)) + (dims.x - 1) * BYTESPERPIXEL;
    
    for (int i = 0; i < maxBytes; i+=4) {
        if (data[i] > 3) data[i]-=3;
        for (int j = i + 1; j < i + 4; j++){
        if (data[j] > 5)
            data[j]-=5;
    }
    }
    //NSLog(@"Max Bytes %d",maxBytes);
}
#pragma mark - render
-(void) renderParticle:(Particle*)particle{
    //int mult = bytesPerRow / dims.x;
    [self renderPixelatX:particle.postion.x andY:particle.postion.y withColor:particle.color];
    //NSLog(@"%f %f %f %f",particle.postion.x, particle.postion.y, [particle getPrevious].x, [particle getPrevious].y);
    [self LineBresenhamwithX1:particle.postion.x andX2:[particle getPrevious].x
                    andY1:particle.postion.y andY2:[particle getPrevious].y andColor:particle.color];
}
-(void) renderPixel:(Vec2)pos andColor:(Color)col {
    if (pos.x >= 0 && pos.x < dims.x - 6){
        if (pos.y >= 0 && pos.y < dims.y - 6){
            int byteIndex = 4 * (int) (pos.x) + bytesPerRow * (int)(pos.y);
            data[byteIndex] = col.r;
            data[byteIndex + 1] = col.g;
            data[byteIndex + 2] = col.b;
            /*
             data[byteIndex + bytesPerRow] = particle.color.r;
             data[byteIndex + bytesPerRow + 1] = particle.color.g;
             data[byteIndex + bytesPerRow + 2] = particle.color.b;
             
             data[byteIndex + 4] = particle.color.r;
             data[byteIndex + 5] = particle.color.g;
             data[byteIndex + 6] = particle.color.b;
             
             data[byteIndex + bytesPerRow + 4] = particle.color.r;
             data[byteIndex + bytesPerRow + 5] = particle.color.g;
             data[byteIndex + bytesPerRow + 6] = particle.color.b;
             */
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
-(void) LineBresenhamwithX1:(int)p1x andX2:(int)p2x andY1:(int)p1y andY2:(int)p2y andColor:(Color)col
{
    int F, x, y;
    
    if (p1x > p2x)  // Swap points if p1 is on the right of p2
    {
        swap(&p1x, &p2x);
        swap(&p1y, &p2y);
    }
    
    // Handle trivial cases separately for algorithm speed up.
    // Trivial case 1: m = +/-INF (Vertical line)
    if (p1x == p2x)
    {
        if (p1y > p2y)  // Swap y-coordinates if p1 is above p2
        {
            swap(&p1y, &p2y);
        }
        
        x = p1x;
        y = p1y;
        while (y <= p2y)
        {
            [self renderPixelatX:x andY:y withColor:col];
            y++;
        }
        return;
    }
    // Trivial case 2: m = 0 (Horizontal line)
    else if (p1y == p2y)
    {
        x = p1x;
        y = p1y;
        
        while (x <= p2x)
        {
            [self renderPixelatX:x andY:y withColor:col];
            x++;
        }
        return;
    }
    
    
    int dy            = p2y - p1y;  // y-increment from p1 to p2
    int dx            = p2x - p1x;  // x-increment from p1 to p2
    int dy2           = (dy << 1);  // dy << 1 == 2*dy
    int dx2           = (dx << 1);
    int dy2_minus_dx2 = dy2 - dx2;  // precompute constant for speed up
    int dy2_plus_dx2  = dy2 + dx2;
    
    
    if (dy >= 0)    // m >= 0
    {
        // Case 1: 0 <= m <= 1 (Original case)
        if (dy <= dx)
        {
            F = dy2 - dx;    // initial F
            
            x = p1x;
            y = p1y;
            while (x <= p2x)
            {
                [self renderPixelatX:x andY:y withColor:col];
                if (F <= 0)
                {
                    F += dy2;
                }
                else
                {
                    y++;
                    F += dy2_minus_dx2;
                }
                x++;
            }
        }
        // Case 2: 1 < m < INF (Mirror about y=x line
        // replace all dy by dx and dx by dy)
        else
        {
            F = dx2 - dy;    // initial F
            
            y = p1y;
            x = p1x;
            while (y <= p2y)
            {
                [self renderPixelatX:x andY:y withColor:col];
                if (F <= 0)
                {
                    F += dx2;
                }
                else
                {
                    x++;
                    F -= dy2_minus_dx2;
                }
                y++;
            }
        }
    }
    else    // m < 0
    {
        // Case 3: -1 <= m < 0 (Mirror about x-axis, replace all dy by -dy)
        if (dx >= -dy)
        {
            F = -dy2 - dx;    // initial F
            
            x = p1x;
            y = p1y;
            while (x <= p2x)
            {
                [self renderPixelatX:x andY:y withColor:col];
                if (F <= 0)
                {
                    F -= dy2;
                }
                else
                {
                    y--;
                    F -= dy2_plus_dx2;
                }
                x++;
            }
        }
        // Case 4: -INF < m < -1 (Mirror about x-axis and mirror
        // about y=x line, replace all dx by -dy and dy by dx)
        else
        {
            F = dx2 + dy;    // initial F
            
            y = p1y;
            x = p1x;
            while (y >= p2y)
            {
                [self renderPixelatX:x andY:y withColor:col];
                if (F <= 0)
                {
                    F += dx2;
                }
                else
                {
                    x++;
                    F += dy2_plus_dx2;
                }
                y--;
            }
        }
    }
}

-(void) spawn1000Particles {
    for (int p = 0; p < 1000; p++){
        
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
    Graviton *grav = [[Graviton alloc] initWithStrength:5.0f andSuction:2.0f andPosition:(Vec2){ .x = dims.x / 2, .y = dims.y/2}];
    [forces addObject:grav];        
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
