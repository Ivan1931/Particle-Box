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

@synthesize smallMenu;
@synthesize menuButton;
@synthesize calc;
@synthesize renderLink;
@synthesize calculateLink;
@synthesize glview;

-(id) initWithSize:(CGRect)size andColor:(UIColor*)color {
    self = [super init];
    
    if (self)
    {        //
        width = size.size.width;
        height = size.size.height;
        [self setupOpenGL];
        calc = [[Calculator alloc] initWithData:particleData andDimesions:VEC2(size.size.width, size.size.height)];
        //Add the small menu button
        
        float _size = size.size.width * BUTTON_WIDTH_RATIO;
        CGRect buttonFrame = CGRectMake(0.f,
                                        height - 2 * _size, _size, _size);
        menuButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        menuButton.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.f];
        menuButton.frame = buttonFrame;
        [menuButton setBackgroundImage:[UIImage imageNamed:@"Untitled.png"] forState:UIControlStateNormal];
        [menuButton setOpaque:YES];
        [menuButton addTarget:self action:@selector(menuButtonSelected) forControlEvents:UIControlEventTouchUpInside];
        
        [self.glview addSubview:menuButton];
        //Add the small menu and make it invisible for now
        smallMenu = [[SmallMenuView alloc] initWithFrame:CGRectMake(_size, height - 2 * _size, width, _size) forceMode:0];
        
        [smallMenu setHidden:YES];
        smallMenuOpen = NO;
        [self.glview addSubview:smallMenu];
        //
        [self setTargetsForSmallMenuBtns];
        [self.glview setMultipleTouchEnabled:YES];
        //////////
                
        numAvailableModes = NUM_FMODE_TYPES;
        numFingers = 0;
    }
    return self;
}

-(void) setupOpenGL {
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:context];
    self.glview = [[GLView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    self.view = glview;
    //Create render buffers
    glGenRenderbuffers(1, &renderBuffer);
    //This binds renderBuffer to GL_RENDERBUFFER. Essentially opengl has created an alias for renderbuffer
    glBindRenderbuffer(GL_RENDERBUFFER, renderBuffer);
    [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer*)glview.layer];
    
    //Set up framebuffer
    glGenFramebuffers(1, &frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, renderBuffer);
    
    glViewport(0, 0, width, height);
    
    glClearColor(0.f, 0.f, 0.f, 1.f);
    glClear(GL_COLOR_BUFFER_BIT);
   
    [self compileShaders];
    
    particleData = (GLfloat*)malloc(sizeof(GLfloat) * MAX_PARTICLES * POINTS_PER_PARTICLE);
        
    const char *aPositionCString = [@"a_position" cStringUsingEncoding:NSUTF8StringEncoding];
    aPosition = glGetAttribLocation(program, aPositionCString);
    glVertexAttribPointer(aPosition, 2, GL_FLOAT, GL_FALSE, 0, particleData);
    glEnableVertexAttribArray(aPosition);
    
    const char *ColorCString = [@"Color" cStringUsingEncoding:NSUTF8StringEncoding];
    colorPosition = glGetUniformLocation(program, ColorCString);
    
    
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    //glEnable(GL_LUMINANCE);
    glLineWidth(2);
    glDrawArrays(GL_LINES, 0, MAX_PARTICLES);
    
    [context presentRenderbuffer:GL_RENDERBUFFER];
	// Do any additional setup after loading the view.

}

-(void) compileShaders {
    NSString *vertexShaderSource = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"VertexShader" ofType:@"vsh"] encoding:NSUTF8StringEncoding error:nil];
    const char *vertexShaderSourceCString = [vertexShaderSource cStringUsingEncoding:NSUTF8StringEncoding];
    
    GLuint vertexShader = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vertexShader, 1, &vertexShaderSourceCString, NULL);
    glCompileShader(vertexShader);
    if (![self validateShaderCompilation:vertexShader]) exit(0);
    
    NSString *fragmentShaderSource = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FragmentShader" ofType:@"fsh"] encoding:NSUTF8StringEncoding error:nil];
    const char *fragmentShaderSourceCString = [fragmentShaderSource cStringUsingEncoding:NSUTF8StringEncoding];
    GLuint fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragmentShader, 1, &fragmentShaderSourceCString, NULL);
    glCompileShader(fragmentShader);
    if (![self validateShaderCompilation:fragmentShader]) exit(0);
    
    
    program = glCreateProgram();
    glAttachShader(program, vertexShader);
    glAttachShader(program, fragmentShader);
    glLinkProgram(program);
    
    glUseProgram(program);
}

-(BOOL) validateShaderCompilation:(GLuint) shader {
    GLint compilationStatus;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compilationStatus);
    if (compilationStatus == GL_TRUE)
        return YES;
    else {
        char buffer[512];
        glGetShaderInfoLog(shader, 512, NULL, buffer);
        NSLog(@"%s",buffer);
        return  NO;
    }

}


-(void) setTargetsForSmallMenuBtns {
    //
    [smallMenu.btnStepUpMode addTarget:self action:@selector(cycleThroughFNodes:) forControlEvents:UIControlEventTouchUpInside];
    
    [smallMenu.btnScreenShot addTarget:self action:@selector(saveImage:) forControlEvents:UIControlEventTouchUpInside];
}
-(void) render:(CADisplayLink*) link  {
    //NSLog(@"Rendering");
    [calc calculate:link];
    [self draw];
    
}

-(void) draw {
    glUniform4f(colorPosition, 1.f, .2f, .7f, 1.f);
    glVertexAttribPointer(aPosition, 2, GL_FLOAT, GL_FALSE, 0, particleData);
    glDrawArrays(GL_LINES, 0, [calc numParticles]);
    [context presentRenderbuffer:GL_RENDERBUFFER];
    glClearColor(0.f, 0.f, 0.f, 1.f);
    glClear(GL_COLOR_BUFFER_BIT);
}

-(void)menuButtonSelected {
    [smallMenu setHidden:smallMenuOpen];
    smallMenuOpen = !smallMenuOpen;
}

-(void) moveForces:(CGPoint)xy {
    [calc moveGravity:xy];
}

-(IBAction) saveImage:(id) sender {
    NSLog(@"Image saved");
    [self pause];
    [self resume];
}

-(IBAction)cycleThroughFNodes:(id)sender  {
    NSLog(@"Mode increased");
    [self pause];
    int tmp = [calc currentNodeType];
    tmp = (tmp == numAvailableModes - 1) ? 0 : tmp + 1;
    [calc setForceNode:tmp];
    [self resume];
}

-(void) pause {
    [calculateLink setPaused:YES];
    [renderLink setPaused:YES];
}

-(void) resume {
    [calculateLink setPaused:NO];
    [renderLink setPaused:NO];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touches began with numfingers %d", [touches count]);
    NSLog(@"Num nodes %d\n", [calc.node getNumberNodes]);
    for (int i = 0 ; i < [touches count]; i++) {
        CGPoint point = [[[touches allObjects] objectAtIndex:i] locationInView:glview];
        [calc.node addNode:VEC2(point.x, point.y)];
    }
       
   
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touches moved with fingers %d", [touches count]);
    NSLog(@"Num nodes %d\n", [calc.node getNumberNodes]);
    for (int i = 0 ; i < [touches count]; i++){
        CGPoint p = [[[touches allObjects] objectAtIndex:i] locationInView:glview];
        [calc moveGravity:p];
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touch ended fingers %d ", [touches count]);
    NSLog(@"Num nodes %d\n", [calc.node getNumberNodes]);
    numFingers -= [touches count];
    for (int i = 0 ; i < [touches count]; i++) {
            CGPoint point = [[[touches allObjects] objectAtIndex:i] locationInView:glview];
            [calc.node deleteNode:VEC2(point.x, point.y)];
    }
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touches cancelled with fingers %d", [touches count]);
    NSLog(@"Num nodes %d\n", [calc.node getNumberNodes]);
    [calc.node deleteNodes];
}

@end
