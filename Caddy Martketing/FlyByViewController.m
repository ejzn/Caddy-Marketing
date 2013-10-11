//
//  FlyByViewController.m
//  Caddy Martketing
//
//  Created by Erik Johnson on 2013-10-10.
//  Copyright (c) 2013 Erik Johnson. All rights reserved.
//

#import "FlyByViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface FlyByViewController ()

    @property (nonatomic, strong) IBOutlet MPMoviePlayerViewController *movieController;

@end

@implementation FlyByViewController

    @synthesize movieController;

    - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
    {
        self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
        if (self) {
            // Custom initialization
        }
        return self;
    }

    - (void)viewDidLoad
    {
        [super viewDidLoad];
        
        //NSURL *movieURL = [NSURL fileURLWithPath:@"hole_1_SPRUCE.mp4"];
        
        NSURL *myURL = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"hole_1_SPRUCE" ofType:@"mp4"]];
        movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:myURL];
        
        
        if (movieController.moviePlayer != nil){
            NSLog(@"Instantiated movie player.");
            
            //Add a callback to hide the controls
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidecontrol)
                                                         name:MPMoviePlayerLoadStateDidChangeNotification
                                                       object:movieController.moviePlayer];
            
            movieController.moviePlayer.fullscreen = YES;
            movieController.moviePlayer.scalingMode = MPMovieScalingModeFill;
            movieController.moviePlayer.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            movieController.moviePlayer.controlStyle = MPMovieControlModeHidden;
            
            [movieController.moviePlayer prepareToPlay];
            [movieController.moviePlayer play];
            movieController.moviePlayer.initialPlaybackTime =  -1.0;
            [self.view addSubview:movieController.moviePlayer.view];
        } else {
            NSLog(@"Failed to instantiate the movie player.");
        }
        
    
        // Do any additional setup after loading the view.
    }

    - (void) hidecontrol {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerNowPlayingMovieDidChangeNotification object:movieController.moviePlayer];
        [movieController.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
        
    }

    - (void)didReceiveMemoryWarning
    {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
    }

@end
