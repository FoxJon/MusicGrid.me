//
//  SLFLogInVC.m
//  Selfie
//
//  Created by Jonathan Fox on 4/22/14.
//  Copyright (c) 2014 Jon Fox. All rights reserved.
//

#import "MGMLogInVC.h"
#import "MGMSignUpVC.h"
#import "MGMViewController.h"
#import "MGMArtistsViewController.h"
#import <Parse/Parse.h>

@interface MGMLogInVC () <FBLoginViewDelegate>

@property (strong, nonatomic) FBProfilePictureView *profilePic;

@property (strong, nonatomic) UILabel *labelFirstName;
@property (strong, nonatomic)  FBProfilePictureView *profilePictureView;
@property (strong, nonatomic)  UILabel *nameLabel;
@property (strong, nonatomic)  UILabel *statusLabel;

@property (strong, nonatomic) id<FBGraphUser> loggedInUser;
@end

@implementation MGMLogInVC
{
    UITextField * userNameLabel;
    UITextField * passwordLabel;
    UIActivityIndicatorView * spinner;
    UIView *newForm;
    UIImageView * signUpBackground;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor colorWithRed:0.016f green:0.863f blue:0.529f alpha:1.0f];
        
        newForm = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
        [self.view addSubview:newForm];

        signUpBackground = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,568, 315)];
        signUpBackground.image = [UIImage imageNamed:@"popup"];
        signUpBackground.contentMode = UIViewContentModeScaleToFill;
        [newForm addSubview:signUpBackground];
        
        UIImageView * closeButton = [[UIImageView alloc]initWithFrame:CGRectMake(523,10,29,29)];
        closeButton.contentMode = UIViewContentModeScaleToFill;
        closeButton.image = [UIImage imageNamed:@"close_button"];
        [signUpBackground addSubview:closeButton];
        
        UIImageView * plug = [[UIImageView alloc]initWithFrame:CGRectMake(0, 30,150, 40)];
        plug.image = [UIImage imageNamed:@"jack"];
        plug.contentMode = UIViewContentModeScaleToFill;
        [signUpBackground addSubview:plug];
        
        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_HEIGHT/2-100), 0, 200, 100)];
        title.text = @"Plug in...";
        title.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50.0];
        title.textAlignment = 1;
        [newForm addSubview:title];
        
        userNameLabel = [[UITextField alloc]initWithFrame:CGRectMake((SCREEN_HEIGHT/2-160), 100, 330, 40)];
        userNameLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.05];
        userNameLabel.layer.cornerRadius = 4;
        userNameLabel.delegate = self;
        userNameLabel.leftViewMode = UITextFieldViewModeAlways;
        userNameLabel.placeholder = @" Enter user name";
        userNameLabel.textColor = [UIColor colorWithWhite:0.0 alpha:0.2];
        
        userNameLabel.delegate = self;

        [newForm addSubview:userNameLabel];

        passwordLabel = [[UITextField alloc]initWithFrame:CGRectMake((SCREEN_HEIGHT/2-160), 150, 330, 40)];
        passwordLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.05];
        passwordLabel.layer.cornerRadius = 4;
        passwordLabel.delegate = self;
        passwordLabel.leftViewMode = UITextFieldViewModeAlways;
        passwordLabel.placeholder = @" Enter Password";
        passwordLabel.textColor = [UIColor colorWithWhite:0.0 alpha:0.2];
        passwordLabel.secureTextEntry = YES;
        
        passwordLabel.delegate = self;
        
        [newForm addSubview:passwordLabel];
        
        //Parse Login Button
        UIButton *submitButton = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_HEIGHT/2-160), 200, 110, 45)];
        [submitButton setTitle:@"LOG IN" forState:UIControlStateNormal];
        [submitButton addTarget:self action:@selector(logIn) forControlEvents:UIControlEventTouchUpInside];
        submitButton.backgroundColor = [UIColor colorWithRed:0.227f green:0.337f blue:0.580f alpha:1.0f];
        submitButton.layer.cornerRadius = 4;
        [newForm addSubview:submitButton];
        
        // Link to sign up page
        UIButton *newUserButton = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_HEIGHT/2-50), 260, 100, 20)];
        [newUserButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
        [newUserButton setTitle:@"New User?" forState:UIControlStateNormal];
        [newUserButton addTarget:self action:@selector(signUp) forControlEvents:UIControlEventTouchUpInside];
        [newUserButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [newForm addSubview:newUserButton];
    }
    return self;
}

// Push to Sign up page
-(void)signUp
{
    MGMSignUpVC *svc = [[MGMSignUpVC alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:svc animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        newForm.frame = CGRectMake(0, 0,568, 320);
    }];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.placeholder = @"";
    textField.textColor = [UIColor blackColor];
    textField.autocorrectionType = FALSE;
    textField.autocapitalizationType = FALSE;
    [UIView animateWithDuration:0.2 animations:^{
        newForm.frame = CGRectMake(0, -90, 320, self.view.frame.size.height);
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    textField.placeholder = @"Enter here";
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    FBLoginView *loginView =
    [[FBLoginView alloc] initWithReadPermissions:
     @[@"public_profile", @"email", @"user_friends", @"user_likes"]];
    
    loginView.frame = CGRectMake((SCREEN_HEIGHT/2-45), 200, 215, 50);
    
    loginView.delegate = self;
    
    [newForm addSubview:loginView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)cancelLogin
{
    MGMViewController *vc = [[MGMViewController alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

//LOGIN WITH PARSE
- (void)logIn{
    spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(160, 400);
    spinner.hidesWhenStopped = YES;
    [spinner setColor:[UIColor orangeColor]];
    [newForm addSubview:spinner];
    [spinner startAnimating];
      
    [PFUser logInWithUsernameInBackground:userNameLabel.text password:passwordLabel.text
    block:^(PFUser *user, NSError *error) {
        
        NSLog(@"logged in %@", user.username);
        NSLog(@"current user %@", [PFUser currentUser].username);

        
        if (user) {
            self.navigationController.navigationBarHidden = YES;
            self.navigationController.viewControllers = @[[[MGMArtistsViewController alloc]initWithNibName:nil bundle:nil]];
        } else {
            NSString * errorDescription = error.userInfo[@"error"];
            
            [spinner removeFromSuperview];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"ERROR" message: errorDescription delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
 
}

//LOGIN WITH FACEBOOK
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    if (user) {
        self.navigationController.navigationBarHidden = YES;
        self.navigationController.viewControllers = @[[[MGMArtistsViewController alloc]initWithNibName:nil bundle:nil]];
    }else{
    // here we use helper properties of FBGraphUser to dot-through to first_name and
    // id properties of the json response from the server; alternatively we could use
    // NSDictionary methods such as objectForKey to get values from the my json object
    self.labelFirstName.text = [NSString stringWithFormat:@"Hello %@!", user.first_name];
    // setting the profileID property of the FBProfilePictureView instance
    // causes the control to fetch and display the profile picture for the user
    self.profilePictureView.profileID = user.objectID;
    self.nameLabel.text = user.name;
    self.profilePic.profileID = user.objectID;
    self.loggedInUser = user;
    self.navigationController.navigationBarHidden = YES;
    }
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    // see https://developers.facebook.com/docs/reference/api/errors/ for general guidance on error handling for Facebook API
    // our policy here is to let the login view handle errors, but to log the results
    NSString *alertMessage, *alertTitle;
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    self.statusLabel.text = @"You're logged in as";
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    self.profilePictureView.profileID = nil;
    self.nameLabel.text = @"";
    self.statusLabel.text= @"You're not logged in!";
}

-(BOOL)prefersStatusBarHidden {return YES;}

@end
