//
//  Engine.m
//  Particle Box
//
//  Created by Jonah Hooper on 2013/03/25.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//


#import "Engine.h"

typedef unsigned char byte;

#define Clamp255(a) (a>255 ? 255 : a)

const float BUTTON_WIDTH_RATIO = 1.f / 10.f;

@implementation Engine

@synthesize menuButton;
@synthesize calc;
@synthesize renderLink;
@synthesize calculateLink;
int startX = 0;
int startY = 0;

-(id) initWithSize:(CGRect)size andColor:(UIColor*)color {
    self = [super initWithFrame:size];
    
    if (self)
    {        //
        width = size.size.width;
        height = size.size.height;
        colorSpace = CGColorSpaceCreateDeviceRGB();
        //
        
        float _size = size.size.width * BUTTON_WIDTH_RATIO;
        CGRect buttonFrame = CGRectMake(0.f,
                                        height - 2 * _size, _size, _size);
        menuButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        menuButton.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.f];
        menuButton.frame = buttonFrame;
        [menuButton setBackgroundImage:[UIImage imageNamed:@"Untitled.png"] forState:UIControlStateNormal];
        [menuButton setOpaque:YES];
        [menuButton addTarget:self action:@selector(menuButtonSelected) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:menuButton];
        
        image = [self makeCalc:self.bounds];
        calculateLink = [CADisplayLink displayLinkWithTarget:calc selector:@selector(calculate:)];
        renderLink  =[CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
        [calculateLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        [renderLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        
        
       
    }
    return self;
}

-(void) clearRaster:(CADisplayLink*) link  {
    //NSLog(@"Clear Raster");
    
    size_t bytesPerRow      = (width * BITSPERCOMPONENT * BYTESPERPIXEL + 7) / 8;
    for (int y = startY ; y < height/2 + startY; y++)
    {
        for (int x = startX; x < width /2 + startX; x++)
        {
            int byteIndex = (bytesPerRow * y) + x * BYTESPERPIXEL;
            data[byteIndex] = 255;
            data[byteIndex + 1] = 255;
            data[byteIndex + 2] = 255;
            
        }
    }
    if (startX >= width / 2) {
        startX = 0;
    } else startX++;
    if (startY >= height / 2) {
        startY = 0;
    } else startY++;
}

-(void) updateImage{
    size_t bytesPerRow      = (width * BITSPERCOMPONENT * BYTESPERPIXEL + 7) / 8;
    CGContextRef context = CGBitmapContextCreate(data, width, height,
                                                 BITSPERCOMPONENT,
                                                 bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    
    //CGColorSpaceRelease(colorSpace);
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGContextRelease(context);
    //free(data);
    
    
}

-(void) render:(CADisplayLink*) link  {
    //NSLog(@"Render");
    @try {
        [self updateImage];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception");
    }
    [self drawImage:image];
    
}

- (UIImage*)makeCalc: (CGRect)rect
{
    size_t bitsPerComponent = 8;
    size_t bytesPerPixel    = 4;
    size_t bytesPerRow      = (width * bitsPerComponent * bytesPerPixel + 7) / 8;
    size_t dataSize         = bytesPerRow * height;
    
    data = malloc(dataSize);
    memset(data, 0, dataSize);
    
    CGContextRef context = CGBitmapContextCreate(data, width, height,
                                                 bitsPerComponent,
                                                 bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    calc = [[Calculator alloc] initWithData:data andDimesions:(Vec2){rect.size.width, rect.size.height}];
    CGColorSpaceRelease(colorSpace);
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *result = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGContextRelease(context);
    //free(data);
    return result;
}

-(void) drawImage:(UIImage*)pimage{
    self.layer.contents = (id)pimage.CGImage;
}

-(void)menuButtonSelected {
    NSLog(@"Button pressed");
}

-(void) moveForces:(CGPoint)xy {
    [calc moveGravity:xy];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touch recieved");
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touch recieved");
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touch recieved");
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touch recieved");
}

@end
