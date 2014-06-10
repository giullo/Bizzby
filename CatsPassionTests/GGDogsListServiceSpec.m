//
//  GGCatsListServiceSpec.m
//  CatsPassion
//
//  Created by giuliano galea on 10/06/2014.
//  Copyright (c) 2014 Giuliano Galea. All rights reserved.
//

#import "Kiwi.h"
#import "GGDogsListService.h"
#import "GGDog.h"
#import <AFNetworking/AFNetworking.h>
#import <OHHTTPStubs/OHHTTPStubs.h>

SPEC_BEGIN(GGDogsListServiceSpec)

describe(@"GGDogsListService", ^{
    
    
    NSString *dogName0 = @"Fido";
    NSString *dogName1 = @"Rex";
    NSURL *dogURL0 = [NSURL URLWithString:@"http://some.url.to/0"];
    NSURL *dogURL1 = [NSURL URLWithString:@"http://some.url.to/1"];
    NSString *json = [NSString stringWithFormat:@"{\"dogs\": [{\"name\": \"%@\",\"id\": 0,\"url\": \"%@\"},{\"name\": \"%@\",\"id\": 1,\"url\": \"%@\"}]}", dogName0, dogURL0, dogName1, dogURL1];
    __block BOOL shouldFail = NO;
    beforeEach(^{
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return YES;
        } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
            NSDictionary *headers = @{};
            NSData *data           = [json dataUsingEncoding:NSUTF8StringEncoding];
            if (shouldFail) {
                data = nil;
            } else {
                headers = @{@"Content-Type" : @"application/json"};
            }
            return [[OHHTTPStubsResponse responseWithData:data
                                               statusCode:(shouldFail) ? 500 : 200
                                                  headers:headers] responseTime:0.2];
        }];
    });
    
    afterEach(^{
        [OHHTTPStubs removeAllStubs];
    });
    
    context(@"when created with an URL and data is fetched", ^{
        it(@"should return already deserialized data", ^{
            __block NSError *blockError = [NSError errorWithDomain:@"" code:100 userInfo:nil];
            __block NSArray *items;
            AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
            GGDogsListService *service = [[GGDogsListService alloc] initWithURL:[NSURL URLWithString:@"http://some.url.to"] sessionManager:sessionManager];
            [service fetchDataWithRange:NSMakeRange(0, 0) withCompletionBlock:^(id data, NSError *error) {
                items = data;
                blockError = error;
            }];
            [[expectFutureValue(blockError) shouldEventuallyBeforeTimingOutAfter(3)] beNil];
            [[expectFutureValue(@(items.count)) shouldEventuallyBeforeTimingOutAfter(3)] equal:@(2)];
            [[expectFutureValue([items[0] anotherName]) shouldEventuallyBeforeTimingOutAfter(3)] equal:dogName0];
            [[expectFutureValue([items[1] anotherName]) shouldEventuallyBeforeTimingOutAfter(3)] equal:dogName1];
            [[expectFutureValue([items[0] URL]) shouldEventuallyBeforeTimingOutAfter(3)] equal:dogURL0];
            [[expectFutureValue([items[1] URL]) shouldEventuallyBeforeTimingOutAfter(3)] equal:dogURL1];
            
        });
    });
});

SPEC_END