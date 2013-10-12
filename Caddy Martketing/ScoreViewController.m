//
//  ScoreViewController.m
//  Caddy Martketing
//
//  Created by Erik Johnson on 2013-10-10.
//  Copyright (c) 2013 Erik Johnson. All rights reserved.
//

#import "ScoreViewController.h"
#import <RevMobAds/RevMobAds.h>

@interface ScoreViewController ()

@end

@implementation ScoreViewController

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
    [[RevMobAds session] showFullscreen];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
