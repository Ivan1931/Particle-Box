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

const float BUTTON_WIDTH_RATIO = 1.f / 8.f;


@implementation Engine

@synthesize smallMenu;
@synthesize menuButton;
@synthesize calc;
@synthesize renderLink;
@synthesize calculateLink;
@synthesize glview;
@synthesize optionPane;

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
        smallMenu = [[SmallMenuView alloc] initWithFrame:CGRectMake(width, height - 2 * _size, width, _size) forceMode:0];
        [self.glview addSubview:smallMenu];
        smallMenuOpen = NO;
        [self setTargetsForSmallMenuBtns];
        
        helpView = [[HelpView alloc] initWithFrame:CGRectMake(0.f, height, width, height)];
        [self.glview addSubview:helpView];
        [helpView.btnExit addTarget:self action:@selector(hideHelp) forControlEvents:UIControlEventTouchUpInside];
        
        optionPane = [[OptionPane alloc] initWithFrame:CGRectMake(0.f, height, width, height)];
        [optionPane.btnExit addTarget:self action:@selector(closeOptions) forControlEvents:UIControlEventTouchUpInside];
        [self.glview addSubview:optionPane];
        //
        
        [self.glview setMultipleTouchEnabled:YES];
        //////////
                
        numAvailableModes = NUM_FMODE_TYPES;
        numFingers = 0;
        
        [self synchroniseOptionSettings];
        
        animatingSmallMenu = NO;
        animatingHelpView = NO;
        
        stickyFingers = NO;
        
        //[calc setStagnateMode:YES];
    }
    return self;
}

-(void) setupOpenGL {
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    self.glview = [[GLView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    self.view = glview;
    [EAGLContext setCurrentContext:context];
    CAEAGLLayer *eaglLayer = (CAEAGLLayer*) glview.layer;
    eaglLayer.opaque = YES;
    eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithBool:YES],
                                    kEAGLDrawablePropertyRetainedBacking,
                                    kEAGLColorFormatRGB565, kEAGLDrawablePropertyColorFormat, nil];
    
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
    
    glClearColor(0.f, 0.f, 0.f, 0.f);
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
    glBlendEquation( GL_FUNC_ADD );
    glLineWidth(2);
    glDrawArrays(GL_LINES, 0, MAX_PARTICLES);
    glEnable(GL_APPLE_framebuffer_multisample);
    
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

-(void) openOptions {
    [self pause];
    CGRect final = CGRectMake(0.f, 0.f, width, height);
    [UIView animateWithDuration:0.5
                        delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                        animations:^{
                         optionPane.frame = final;
                        }completion:^(BOOL finished){
                         [self hideSmallMenu];
                        }];
    
}

-(void) closeOptions {
    CGRect final = glview.frame;
    final.origin.y = glview.frame.size.height;
    [self synchroniseOptionSettings];
    [self saveSettings];
    if(!stickyFingers)
        [calc.node deleteNodes];
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         optionPane.frame = final;
                     }completion:^(BOOL finished){
                         [self resume];
                     }];
}

-(void) saveSettings {
    float red = ((LabeledSlider *)optionPane.sldrColors[0]).slider.value;
    float green = ((LabeledSlider *)optionPane.sldrColors[1]).slider.value ;
    float blue = ((LabeledSlider *)optionPane.sldrColors[2]).slider.value;
    
    float particles = (int)optionPane.sldrNumParticle.slider.value;
    float velocity = optionPane.sldrVelocity.slider.value;
    float thickness = optionPane.sldrThickness.slider.value;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setFloat:red forKey:@KEY_RED];
    [defaults setFloat:green forKey:@KEY_GREEN];
    [defaults setFloat:blue forKey:@KEY_BLUE];
    
    [defaults setFloat:particles forKey:@KEY_NUM_PARTICLES];
    [defaults setFloat:velocity forKey:@KEY_VELOCITY];
    [defaults setFloat:thickness forKey:@KEY_THICKNESS];
    
}

-(float) loadFloatFromUserDefaultsForKey:(NSString *)key {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults floatForKey:key];
}

-(void) saveFloatToUserDefaults:(float)x forKey:(NSString *)key {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setFloat:x forKey:key];
    [userDefaults synchronize];
}

-(void) setTargetsForSmallMenuBtns {
    //
    [smallMenu.btnNextMode addTarget:self action:@selector(cycleThroughFNodes:) forControlEvents:UIControlEventTouchUpInside];
    [smallMenu.btnPreviousMode addTarget:self action:@selector(cycleBackThroughForceNodes) forControlEvents:UIControlEventTouchUpInside];
    [smallMenu.btnOpenOptions addTarget:self action:@selector(openOptions) forControlEvents:UIControlEventTouchUpInside];
    [smallMenu.btnStickyFingers addTarget:self action:@selector(stickyFingersSelected) forControlEvents:UIControlEventTouchUpInside];
    [smallMenu.btnHelp addTarget:self action:@selector(showHelp) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void) render:(CADisplayLink*) link  {
    [calc calculate:link];
    [self draw];
    
}

-(void) showHelp {
    if (!animatingHelpView) {
        CGRect final = helpView.frame;
        final.origin.y = 0.f;
        animatingHelpView = YES;
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^(void) {
                             helpView.frame = final;
                         }
                         completion:^(BOOL completion) {
                             animatingHelpView = NO;
                         }];
    }
}

-(void) hideHelp {
    if (!animatingHelpView) {
        CGRect final = helpView.frame;
        final.origin.y = height;
        animatingHelpView = YES;
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^(void) {
                             helpView.frame = final;
                         }
                         completion:^(BOOL completion) {
                             animatingHelpView = NO;
                         }];
    }
}

-(void) synchroniseOptionSettings {
    [calc resetParticles];
    color[3] = 1.f;
    for (int i = 0 ; i < 3; i++)
        color[i] = ((LabeledSlider *)[optionPane.sldrColors objectAtIndex:i]).slider.value;
    glLineWidth(optionPane.sldrThickness.slider.value);
    glPointSize(optionPane.sldrThickness.slider.value);
    [calc setNumParticles:optionPane.sldrNumParticle.slider.value];
    [calc setVelocityMultiplyer:optionPane.sldrVelocity.slider.value];
    
    
}

-(void) draw {
    if (![calc stagnateMode] || ([calc.node getNumberNodes] > 0)) {
        if ([calc.node requiresFadeEffect]) {
            glUniform4f(colorPosition, 0.f, 0.f, 0.f, 0.3f);
            glVertexAttribPointer(aPosition, 2, GL_FLOAT, GL_FALSE, 0, overLay);
            glDrawArrays(GL_TRIANGLE_STRIP, 0, sizeof(overLay) / sizeof(GLfloat));
        } else {
            glClearColor(0.f, 0.f, 0.f, 0.f);
            glClear(GL_COLOR_BUFFER_BIT);
        }
    }
    glUniform4f(colorPosition, color[0], color[1], color[2], 0.f);
    glVertexAttribPointer(aPosition, 2, GL_FLOAT, GL_FALSE, 0, particleData);
    glDrawArrays(GL_LINES, 0, [calc numParticles]);
    [context presentRenderbuffer:GL_RENDERBUFFER];
    
}

-(void)menuButtonSelected {
    if (smallMenuOpen)
        [self hideSmallMenu];
    else
        [self showSmallMenu];
    
}

-(void) stickyFingersSelected {
    if (!stickyFingers && ![calc stagnateMode]) {
        [self stickyFingersOn];
    }
    else if (stickyFingers){
        [self stickyFingersOff];
        [self stagnateModeOn];
    } else {
        [self stagnateModeOff];
    }
}

-(void) stagnateModeOn {
    [smallMenu.btnStickyFingers setTitle:@STAGNATE_ON_STR forState:UIControlStateNormal];
    [calc setStagnateMode:YES];
}

-(void) stagnateModeOff {
    [smallMenu.btnStickyFingers setTitle:@STICKY_FINGER_OFF_STR forState:UIControlStateNormal];
    [calc setStagnateMode:NO];
}

-(void) stickyFingersOn {
    stickyFingers = YES;
    [smallMenu.btnStickyFingers setTitle:@STICKY_FINGER_ON_STR forState:UIControlStateNormal];
}

-(void) stickyFingersOff {
    stickyFingers = NO;
    [smallMenu.btnStickyFingers setTitle:@STICKY_FINGER_OFF_STR forState:UIControlStateNormal];
    [calc.node deleteNodes];
    //[calc resetParticles];
}

-(void) hideSmallMenu {
    if (!animatingSmallMenu && smallMenuOpen) {
        animatingSmallMenu = YES;
        CGRect final = smallMenu.frame;
        final.origin.x = smallMenu.frame.size.width;
        [UIView animateWithDuration:0.5 animations:^{
            smallMenu.frame = final;
        }completion:^(BOOL finished) {
            smallMenuOpen = NO;
            animatingSmallMenu = NO;
        }];
    }
}

-(void) showSmallMenu {
    if (!animatingSmallMenu && !smallMenuOpen) {
        animatingSmallMenu = YES;
        CGRect final = smallMenu.frame;
        final.origin.x = menuButton.bounds.origin.x + menuButton.bounds.size.width;
        [UIView animateWithDuration:0.5 animations:^{
            smallMenu.frame = final;
        }completion:^(BOOL finished) {
            smallMenuOpen = YES;
            animatingSmallMenu = NO;
        }];
    }
}

-(void) moveForces:(CGPoint)xy {
    [calc moveGravity:xy];
}

-(IBAction)cycleThroughFNodes:(id)sender  {
    //NSLog(@"Mode increased");
    [self pause];
    int tmp = [calc currentNodeType];
    tmp = (tmp >= numAvailableModes - 1) ? 0 : tmp + 1;
    [calc setForceNode:tmp];
    [self resume];
}

-(void) cycleBackThroughForceNodes {
    [self pause];
    int tmp = [calc currentNodeType];
    tmp = (tmp == 0) ? NUM_FMODE_TYPES - 1 : tmp - 1;
    [calc setForceNode:tmp];
    [self resume];
}

-(void) pause {
     [renderLink setPaused:YES];
}

-(void) resume {
    [renderLink setPaused:NO];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self hideSmallMenu];
    numFingers += [touches count];
    if (!stickyFingers) {
        for (int i = 0; i < [touches count]; i++) {
            CGPoint point = [[[touches allObjects] objectAtIndex:i] locationInView:glview];
            [calc.node addNode:VEC2(point.x, point.y)];
        }
    } else {
        if (numFingers > [[calc node] getNumberNodes]) {
            int nodesToAdd = numFingers - [[calc node] getNumberNodes];
            int nodesToMove = [touches count] - nodesToAdd;
            for (int  i = 0 ; i < nodesToMove; i++) {
                CGPoint point = [[[touches allObjects] objectAtIndex:i] locationInView:glview];
                [calc moveGravity:point];

            }
            for (int i = nodesToMove ; i < [touches count]; i++) {
                CGPoint point = [[[touches allObjects] objectAtIndex:i] locationInView:glview];
                [calc.node addNode:VEC2(point.x, point.y)];

            }
        } else {
            for (int i = 0 ; i < [touches count]; i++) {
                CGPoint p = [[[touches allObjects] objectAtIndex:i] locationInView:glview];
                [calc moveGravity:p];
            }
        }
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self hideSmallMenu];
    for (int i = 0 ; i < [touches count]; i++){
        CGPoint p = [[[touches allObjects] objectAtIndex:i] locationInView:glview];
        [calc moveGravity:p];
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    numFingers -= [touches count];
    if (!stickyFingers) {
        for (int i = 0 ; i < [touches count]; i++) {
                CGPoint point = [[[touches allObjects] objectAtIndex:i] locationInView:glview];
                [calc.node deleteNode:VEC2(point.x, point.y)];
        }
    }
    if ([calc.node getNumberNodes] == 0)
        [calc startStagnationTimer];
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [calc.node deleteNodes];
    [calc startStagnationTimer];
    [self hideSmallMenu];
    numFingers = 0;
}

void delay (clock_t delayTime) {
    clock_t start = clock();
    clock_t end;
    do {
        end = clock();
    } while (end - start < delayTime);
}


-(void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        NSLog(@"Particles Reset");
        [calc resetParticles];
    }
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}


@end
