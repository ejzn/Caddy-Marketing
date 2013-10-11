//
//  HoleViewController.m
//  Caddy Martketing
//
//  Created by Erik Johnson on 2013-10-10.
//  Copyright (c) 2013 Erik Johnson. All rights reserved.
//

#import "HoleViewController.h"

@interface HoleViewController ()

    @property (nonatomic, strong) IBOutlet UIImageView *holeImageView;
    @property (nonatomic, strong) IBOutlet UIImageView *cartImageView;
    @property (nonatomic, strong) IBOutlet UIImageView *pinimageView;

    /* Initial configuration from Map data, as well as
     * from GPS for cart position, and the tee and hole position
     */
    @property CGPoint cartPosition;
    @property CGPoint teePosition;
    @property CGPoint pinPosition;

@end

@implementation HoleViewController

    @synthesize holeImageView;
    @synthesize cartPosition;
    @synthesize teePosition;
    @synthesize pinPosition;

    - (void)viewDidLoad
    {
        [super viewDidLoad];
        
        /* Initialize position, this should come from GPS and map data */
        cartPosition = CGPointMake(171,330); // Random position
        teePosition = CGPointMake(161,496); // Tee position from Tee
        pinPosition = CGPointMake(148,50); // pin position from MAP
        
        
        /* 1. Hole Image: the image map resource to show the map */
        UIImage *image = [UIImage imageNamed:@"Hole_19.jpg"];
        [holeImageView setImage:image];
        [holeImageView setUserInteractionEnabled:YES];
        
        /* Hover animation to give a live appearance to the application */
        CABasicAnimation *hover = [CABasicAnimation animationWithKeyPath:@"position"];
        hover.additive = YES;
        hover.fromValue = [NSValue valueWithCGPoint:CGPointZero];
        hover.toValue = [NSValue valueWithCGPoint:CGPointMake(0.0, -3.0)];
        hover.autoreverses = YES; // Animate back to normal afterwards
        hover.duration = 1.3;
        hover.repeatCount = INFINITY; // Repeat for ever
        [holeImageView.layer addAnimation:hover forKey:@"10"];
        
        /* 2. Cart image */
        UIImage *cartImage = [UIImage imageNamed:@"scooter-50.png"];
        UIImageView *cartImageView = [[UIImageView alloc] initWithImage:cartImage];
        cartImageView.frame = CGRectMake(cartPosition.x, cartPosition.y, 30, 30);
        [self.holeImageView  addSubview:cartImageView];
        
        /* 2. Tee image */
        UIImage *pinImage = [UIImage imageNamed:@"map-marker-128x128.png"];
        UIImageView *pinImageView = [[UIImageView alloc] initWithImage:pinImage];
        pinImageView.frame = CGRectMake(pinPosition.x, pinPosition.y, 30, 30);
        [self.holeImageView  addSubview:pinImageView];
        
        
    }

    - (void)didReceiveMemoryWarning
    {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
    }

    - (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
        UITouch *touch = [[event allTouches] anyObject];
        CGPoint touchLocation = [touch locationInView:self.holeImageView];

        if (CGRectContainsPoint(holeImageView.frame, touchLocation)) {
             NSLog(@"X Touch: %f", touchLocation.x);
             NSLog(@"Y touch: %f", touchLocation.y);
        }

    }

@end
