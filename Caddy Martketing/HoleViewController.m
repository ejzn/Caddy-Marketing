//
//  HoleViewController.m
//  Caddy Martketing
//
//  Created by Erik Johnson on 2013-10-10.
//  Copyright (c) 2013 Erik Johnson. All rights reserved.
//

#import "CaddyAppDelegate.h"
#import "HoleViewController.h"
#import <RevMobAds/RevMobAds.h>


@interface HoleViewController ()

    @property (nonatomic, strong) IBOutlet UIImageView *holeImageView;
    @property (nonatomic, strong) UIImageView *cartImageView;
    @property (nonatomic, strong) UIImageView *pinimageView;
    @property (nonatomic, strong) UITextView *proTip;
    @property (nonatomic, strong) UITextView *toPinView;
    @property NSTimer *timer;
    @property BOOL proTipVisible;
    @property float scaleFactor;

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
    @synthesize proTip;
    @synthesize proTipVisible;
    @synthesize toPinView;
    @synthesize timer;
    @synthesize scaleFactor;

    - (void)viewDidLoad
    {
        [super viewDidLoad];
        
        
        /* Initialize position, this should come from GPS and map data */
        cartPosition = CGPointMake(171,330); // Random position
        teePosition = CGPointMake(181,496); // Tee position from Tee
        pinPosition = CGPointMake(160,50); // pin position from MAP
        
        /* Initialize app delegate */
        CaddyAppDelegate *appDelegate = (CaddyAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        
        /* 1. Hole Image: the image map resource to show the map */
        UIImage *image = [UIImage imageNamed:@"Hole_19.jpg"];
        [holeImageView setImage:image];
        [holeImageView setUserInteractionEnabled:YES];
        
        float deviceScaling = image.size.width / holeImageView.frame.size.width;
        scaleFactor = (deviceScaling/5.6);
        NSLog(@"Scaling: %f", scaleFactor);
        
        /* 2. Cart image */
        UIImage *cartImage = [UIImage imageNamed:@"map-marker-128x128.png"];
        UIImageView *cartImageView = [[UIImageView alloc] initWithImage:cartImage];
        cartImageView.frame = CGRectMake(cartPosition.x, cartPosition.y, 30, 30);
        [self.holeImageView  addSubview:cartImageView];
        
        /* 2. Flag image */
        UIImage *pinImage = [UIImage imageNamed:@"flag.png"];
        UIImageView *pinImageView = [[UIImageView alloc] initWithImage:pinImage];
        pinImageView.frame = CGRectMake(pinPosition.x, pinPosition.y, 30, 30);
        [self.holeImageView  addSubview:pinImageView];
        
        // 3. Set up the Advertisement listeners for the bottome banners add
        [appDelegate.revMovAds.bannerView loadWithSuccessHandler:^(RevMobBannerView *banner) {
            [banner setFrame:CGRectMake(0,holeImageView.frame.size.height - 50,holeImageView.frame.size.width, 50)];
            [self.view addSubview:banner];
                NSLog(@"Ad loaded");
            } andLoadFailHandler:^(RevMobBannerView *banner, NSError *error) {
                NSLog(@"Ad error: %@",error);
            } onClickHandler:^(RevMobBannerView *banner) {
                NSLog(@"Ad clicked");
        }];
        
        
    }
    - (IBAction)ProTipClicked:(id)sender {
        
        if (!proTipVisible) {
            /* Create the pro tip banner, should be read from database, or from file... */
            NSString *messageToShow = @"This hole is a slight curve to the right, with sand traps to the right of the green. Main obstacles are trees to your left, and the sloping green. Lay up on the far left of the fairway for an easier shot at par.";
            
            proTip = [[UITextView alloc] initWithFrame:CGRectMake(10,self.view.center.y - 80, 220, 200)];
            [proTip setText:messageToShow];
            proTip.contentInset = UIEdgeInsetsMake(10,10,10,10);
            [proTip setFont:[ UIFont boldSystemFontOfSize:17.0]];
            [proTip setTextColor:[UIColor whiteColor]];
            [proTip setBackgroundColor:[UIColor blackColor]];
            [proTip setAlpha: 0.6f];
            proTip.clipsToBounds = YES;
            proTip.layer.cornerRadius = 4.0f;
            [self.view addSubview:proTip];
            proTipVisible = true;

        } else {
            proTipVisible = false;
            [proTip removeFromSuperview];
        }
        
    }

    - (void) viewWillDissappear:(BOOL)animated
    {
        [holeImageView.layer removeAllAnimations];
    }

    - (void) viewWillAppear:(BOOL)animated
    {
        /* Hover animation to give a live appearance to the application */
        CABasicAnimation *hover = [CABasicAnimation animationWithKeyPath:@"position"];
        hover.additive = YES;
        hover.fromValue = [NSValue valueWithCGPoint:CGPointZero];
        hover.toValue = [NSValue valueWithCGPoint:CGPointMake(0.0, -3.0)];
        hover.autoreverses = YES; // Animate back to normal afterwards
        hover.duration = 1.3;
        hover.repeatCount = INFINITY; // Repeat for ever
        [holeImageView.layer addAnimation:hover forKey:@"10"];
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
            
            [timer invalidate];
            timer = nil;
            
            [toPinView removeFromSuperview];
            
            NSInteger toPin = abs((int) sqrt(pow(touchLocation.y - pinPosition.y, 2) + pow(touchLocation.x - pinPosition.x, 2))* scaleFactor);
            NSMutableString* pinDist = [NSMutableString stringWithFormat:@"FRONT: %d YDS \nCENTER: %d YDS \nBACK: %d YDS", toPin-40, toPin-25, toPin+5 ];
            
            toPinView = [[UITextView alloc] initWithFrame:CGRectMake(touchLocation.x,touchLocation.y, 95, 50)];
            [toPinView setText:pinDist];
            [toPinView setFont:[UIFont systemFontOfSize:9.5]];
            [toPinView setTextColor:[UIColor whiteColor]];
            [toPinView setBackgroundColor:[UIColor blackColor]];
            [toPinView setAlpha: 0.6f];
            [toPinView setEditable:FALSE];
            toPinView.clipsToBounds = YES;
            toPinView.layer.cornerRadius = 4.0f;
            [self.view addSubview:toPinView];
            
            timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(hideLabel) userInfo:nil repeats:NO];
            
        }

    }

    - (void) hideLabel
    {
        [toPinView removeFromSuperview];
    }

@end
