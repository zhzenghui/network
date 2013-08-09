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
#import "TopIOSClient.h"


@interface ZHViewController ()

@end

@implementation ZHViewController


-(void) authCallback:(id)data
{
    if ([data isKindOfClass:[TopAuth class]])
    {
        TopAuth *auth = (TopAuth *)data;
        
//        [userIds addObject:[auth user_id]];
        
        NSLog(@"%@",[auth user_id]);
        
//        [_userIdText setText:[auth user_id]];
    }
    else
    {
        NSLog(@"%@",data);
    }
    
}


- (IBAction)authAction:(id)sender {
    

    TopIOSClient *iosClient = [TopIOSClient getIOSClientByAppKey:KTaoBaoAppKey];

    TopAuth *auth =  [iosClient getAuthByUserId:@"618386961"];
    
    NSLog(@"%@",[auth user_name]);

    [iosClient auth:self cb:@selector(authCallback:)];
}

- (void)parseData:(UIButton *)button
{
    
    
    
    
}

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


- (void)loginSuccess:(id)responseObject
{
    DLog(@"login  success")

    
    NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    NSLog(@"Request Successful, response '%@'", responseStr);
    
    textField.text = responseStr;
    
    /*
     过期设置
     
     */
    NSMutableDictionary *userDict = [NSMutableDictionary dictionaryWithDictionary:[responseStr objectFromJSONString]];
    
    
    //                 保存用户信息
    
    [[Users share] saveCurrentUser:userDict];
    
    //                 登陆成功调用
    
    
    
//    添加获取信息的按钮    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"获取users信息" forState:UIControlStateNormal];
    button.frame =CGRectMake(20, 200, 280, 50);
    [button addTarget:self  action:@selector(getInfo:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

- (void)networkCheckUserInfo:(NSString *)userName PWD:(NSString *)pwd
{

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wshadow-ivar"
    __block NSString *userNameString = [[NSString alloc] initWithFormat:@"%@", userName];
    __block NSString *userPwdString = [[NSString alloc] initWithFormat:@"%@", pwd ];
#pragma clang diagnostic pop

    dispatch_queue_t myQueue = dispatch_queue_create("com.mycompany.myqueue", 0);
    
    dispatch_async(myQueue, ^{
        

        
        if ([[NetWork shareNetWork] CheckNetwork]) {
            NSLog(@"connection yes");
        }
        else {
            NSLog(@"connection NO");
            [[Message share] messageAlert:@"请检查网络"];
        }
        
        
        
        NSURL *url = [NSURL URLWithString:@"http://localhost:3000/"];
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                userNameString, @"session[email]",
                                userPwdString, @"session[pwd]",
                                nil];

        [httpClient postPath:@"/signin" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"Request Successful, response '%@'", responseStr);
            if ( ! [responseStr isEqualToString:@"NO"]) {
                DLog(@"登陆成功！");
                
                
                [self loginSuccess:responseObject];
                
            }
            else {
                
                DLog(@"发生错误， 返回的数据：%@",  responseStr);
                [[Message share] messageAlert:@"登陆失败，请检查用户名密码！"];
            }
            

            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
            
        }];

    });
    
    dispatch_release(myQueue);
    
}

- (void)login:(UIButton *)b
{
    
//      1.检查用户本地是否存在
//          存在：
//            1.1.1 存在 检查本地是否过期   ----只 汉诺
//                  过期进入网络验证
//            1.1.2 验证用户信息
//          不存在：
//            1.2.1 访问网络检查用户
//          通过：
//            1.3.1.获取用户信息
//    
//      2.网络验证
//
    
    if ( [(Users *)[Users share] name] ) {
        
        DLog(@"current user %@", [(Users *)[Users share] name]);
        
    }
    else {
        DLog(@"not user");
    }
    

    
    if ([netWork checkLocalUserInfo:userName]) {
        
        
        if ([netWork checkLocalUsername:userName PWD:pwd]) {
            DLog(@"验证本地用户信息=======Y");
            
            if ([netWork checkLocalUserInfoExpired:userName]) {
                DLog(@"验证本地用户过期=======Y");
                
                NSLog(@"登陆 SSSSSSSSSSSSS");
                
            }
            else {
                
                [self networkCheckUserInfo:userName PWD:pwd];

                DLog(@"验证本地用户过期=======N");
            }

        }
        else {
            
            DLog(@"验证本地用户信息失败====N");
        }
    }
    else {
        [self networkCheckUserInfo:userName PWD:pwd];
        DLog(@"没有本地用户信息====N");
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    userName = [[NSString alloc ]initWithFormat:@"asdf"];
    pwd = [[NSString alloc ]initWithFormat:@"asdf"];

    netWork = [[NetWork alloc] init];
    
    
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];

    [self .view addSubview:textField];
    [textField release];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"login" forState:UIControlStateNormal];
    button.frame = CGRectMake(20, 100, 280, 50);
    [button addTarget:self  action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button3 setTitle:@"解析json" forState:UIControlStateNormal];
    button3.frame = CGRectMake(20, 300, 280, 50);
    [button3 addTarget:self  action:@selector(parseData:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button3];
    
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button2 setTitle:@"auth taobao" forState:UIControlStateNormal];
    button2.frame = CGRectMake(20, 400, 280, 50);
    [button2 addTarget:self  action:@selector(authAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button2];
    
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button3 setTitle:@"auth taobao" forState:UIControlStateNormal];
    button3.frame = CGRectMake(20, 300, 280, 50);
    [button3 addTarget:self  action:@selector(sendRequestAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button3];
    
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
