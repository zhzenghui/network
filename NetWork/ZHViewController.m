//
//  ZHViewController.m
//  NetWork
//
//  Created by mbp  on 13-7-31.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "ZHViewController.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"

@interface ZHViewController ()

@end

@implementation ZHViewController

- (void)getInfo:(UIButton *)b
{
    
    NSURL *url = [NSURL URLWithString:@"http://localhost:3000/users.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"IP Address: %@", [JSON valueForKeyPath:@"name"]);
        NSString *s = [NSString stringWithFormat:@"%@", JSON];
        textField.text = s;
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"status: %d", response.statusCode);
        

    }];

    [operation start];
}

- (void)login:(UIButton *)b
{
    
    if ([[NetWork shareNetWork] CheckNetwork]) {
        NSLog(@"yes");
        [[Message share] messageAlert:@"YES"];
    }
    else {
        NSLog(@"NO");
        return;
    }
    
    NSURL *url = [NSURL URLWithString:@"http://localhost:3000/"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"asdf", @"session[email]",
                            @"asdf", @"session[pwd]",
                            nil];

    [httpClient postPath:@"/signin" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"Request Successful, response '%@'", responseStr);
        
        textField.text = responseStr;
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:@"获取users信息" forState:UIControlStateNormal];
        button.frame =CGRectMake(20, 200, 280, 50);
        [button addTarget:self  action:@selector(getInfo:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:button];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
    }];

    
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    netWork = [[NetWork alloc] init];
    
    
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];

    [self .view addSubview:textField];
    [textField release];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"login" forState:UIControlStateNormal];
    button.frame = CGRectMake(20, 100, 280, 50);
    [button addTarget:self  action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
//    NSURL *url = [NSURL URLWithString:@"http://localhost:3000/users.json"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    
//    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//        NSLog(@"IP Address: %@", [JSON valueForKeyPath:@"origin"]);
//    } failure:nil];
//    
//    [operation start];
    
    
//    NSURL *url = [NSURL URLWithString:@"http://api-base-url.com"];
//    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
//    NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"avatar.jpg"], 0.5);
//    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"/upload" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
//        [formData appendPartWithFileData:imageData name:@"avatar" fileName:@"avatar.jpg" mimeType:@"image/jpeg"];
//    }];
//    
//    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//        NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
//    }];
//    [httpClient enqueueHTTPRequestOperation:operation];

    
       
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
