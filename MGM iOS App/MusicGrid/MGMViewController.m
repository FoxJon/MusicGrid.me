//
//  MGMViewController.m
//  MusicGrid
//
//  Created by Jonathan Fox on 6/6/14.
//  Copyright (c) 2014 Jonathan Fox. All rights reserved.
//

#import "MGMViewController.h"
#import "MGMLogInVC.h"

@interface MGMViewController ()

@end

@implementation MGMViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIImageView * background = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,568, 320)];
        background.image = [UIImage imageNamed:@"iphone-layout"];
        background.contentMode = UIViewContentModeScaleToFill;
        [self.view addSubview:background];
        
        UIImageView * pulse = [[UIImageView alloc]initWithFrame:CGRectMake(300, 100,175, 100)];
        pulse.image = [UIImage imageNamed:@"logo_color"];
        pulse.contentMode = UIViewContentModeScaleToFill;
        [self.view addSubview:pulse];
        
        UIImageView * appStore = [[UIImageView alloc]initWithFrame:CGRectMake(375, 180,100, 50)];
        appStore.image = [UIImage imageNamed:@"app_store_button"];
        appStore.contentMode = UIViewContentModeScaleToFill;
        [self.view addSubview:appStore];
        
        UILabel * intro = [[UILabel alloc]initWithFrame:CGRectMake(300, 20, 250, 100)];
        intro.text = @"welcome to";
        intro.font = [UIFont fontWithName:@"HelveticaNeue-Ultralight" size:45];
        intro.textColor = [UIColor whiteColor];
        [self.view addSubview:intro];

        
        UIButton * logIn = [[UIButton alloc]initWithFrame:CGRectMake(10, -5, 70, 40)];
        logIn.backgroundColor = [UIColor clearColor];
        logIn.titleLabel.textAlignment = 1;
        [logIn setBackgroundImage:[UIImage imageNamed:@"sign_up_button"] forState:UIControlStateNormal];
        logIn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-light" size:10];
        [logIn setTitle:@"" forState:UIControlStateNormal];
        
        [logIn addTarget:self action:@selector(openLoginPage) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:logIn];
    }
    return self;
}

-(void)openLoginPage
{
    MGMLogInVC *svc = [[MGMLogInVC alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:svc animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden {return YES;}


@end
