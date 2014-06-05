//
//  GGCatsListService.m
//  CatsPassion
//
//  Created by giullo on 05/06/2014.
//  Copyright (c) 2014 Giuliano Galea. All rights reserved.
//

#import "GGService.h"

@interface GGService ()
@property (nonatomic, copy) GGServiceProtocolCompletionBlock completionBlock;
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@end

@implementation GGService

- (instancetype)initWithURL:(NSURL *)url sessionManager:(AFHTTPSessionManager *)sessionManager
{
    self = [super init];
    if (self) {
        _url = url;
        _sessionManager = sessionManager;
    }
    return self;
}

- (void)fetchDataWithRange:(NSRange)range withCompletionBlock:(GGServiceProtocolCompletionBlock)completionBlock
{
    self.completionBlock = completionBlock;
    NSURLRequest *req = [NSURLRequest requestWithURL:self.url];
    NSURLSessionDataTask *task = [self.sessionManager dataTaskWithRequest:req completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        [self processResponseData:responseObject error:error];
    }];
    [task resume];
}

- (void)processResponseData:(id)response error:(NSError *)error
{
    self.completionBlock(response, error);
}

@end
