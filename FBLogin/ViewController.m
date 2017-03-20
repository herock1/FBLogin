//
//  ViewController.m
//  FBLogin
//
//  Created by Herock Hasan on 3/16/17.
//  Copyright © 2017 Herock Hasan. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
       [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    [_fblogin
     addTarget:self
     action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loginButtonClicked
{
    if ([FBSDKAccessToken currentAccessToken]) {
        NSLog(@"Already Logged in");
    }
    else
    {
        
   
    
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logInWithReadPermissions:@[@"email",@"user_birthday",@"user_posts",@"user_about_me"]
                        fromViewController:self
                                   handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                       //TODO: process error or result
                                       NSLog(@"User Info : %@",result);
                                       if (error)
                                       {
                                           
                                           // There is an error here.
                                           
                                       }
                                       else
                                       {
                                        
                                           if(result.token)   // This means if There is current access token.
                                           {    
                                               // Token created successfully and you are ready to get profile info
                                               [self getFacebookProfileInfosNew];
                                           }        
                                       }
                                       
                                   }];
         }
    
}



-(void)getFacebookProfileInfos {
    
    FBSDKGraphRequest *requestMe = [[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:nil];
    
    FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
    
    [connection addRequest:requestMe completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        
        
        if(result)
        {
            if ([result objectForKey:@"email"]) {
                
                NSLog(@"Email: %@",[result objectForKey:@"email"]);
                
            }
            if ([result objectForKey:@"first_name"]) {
                
                NSLog(@"First Name : %@",[result objectForKey:@"first_name"]);
                
            }
            if ([result objectForKey:@"id"]) {
                
                NSLog(@"User id : %@",[result objectForKey:@"id"]);
                
            }
            
        }
        
    }];
    
    [connection start];
}

-(void)getFacebookProfileInfosNew {
    
//    if ([FBSDKAccessToken currentAccessToken]) {
//        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
//         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//             if (!error) {
//                 NSLog(@"fetched user:%@", result);
//             }
//         }];
//    }
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                       parameters:@{@"fields": @"picture.width(480).height(480), email, birthday, age_range, name"}]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             NSLog(@"Result: %@",result);
             NSString *pictureURL = [NSString stringWithFormat:@"%@",[[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]];
             
             NSLog(@"email is %@", [result objectForKey:@"email"]);
             
             NSData  *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:pictureURL]];
             UIImage *image = [UIImage imageWithData:data];
             self.imageView.image = image;
             
         }
         else{
             NSLog(@"%@", [error localizedDescription]);
         }
     }];
//    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
//                                  initWithGraphPath:@"1258602127508936/accounts"
//                                  parameters:nil
//                                  HTTPMethod:@"GET"];
//    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
//                                          id result,
//                                          NSError *error) {
//                     NSLog(@"Result: %@",result);
//
//        // Handle the result
//    }];
    
}

@end
