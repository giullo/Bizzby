//
//  GGModelControllerSpec.m
//  CatsPassion
//
//  Created by giuliano galea on 10/06/2014.
//  Copyright (c) 2014 Giuliano Galea. All rights reserved.
//

#import "Kiwi.h"
#import "GGModelController.h"
#import "GGRemoteService.h"
#import <AFNetworking/AFNetworking.h>
#import <OHHTTPStubs/OHHTTPStubs.h>

@interface GGModelControllerTestDelegate : NSObject <GGModelControllerDelegate>
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) id data;
@property (nonatomic, copy) void (^testBlock) (id data, NSError *error);
@end

@implementation GGModelControllerTestDelegate
- (void)modelController:(id<GGModelControllerProtocol>)modelCtrl didReceiveData:(id)data error:(NSError *)error {
    self.testBlock(data, error);
};
- (void)modelControllerWillFetchData:(id<GGModelControllerProtocol>)modelCtrl {};

@end


SPEC_BEGIN(GGModelControllerSpec)

describe(@"GGModelController", ^{
    
    __block BOOL shouldFail = NO;
    __block NSDictionary *json = @{@"test" : @0};
    __block NSData *data = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
    __block GGModelControllerTestDelegate *testDelegate;
    __block GGModelControllerTestDelegate *testDelegate1;
    __block GGModelController *modelController;
    __block NSError *expectedError;
    __block id expectedData = @"";
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    testDelegate = [GGModelControllerTestDelegate new];
    testDelegate.testBlock = ^(id data, NSError *error) {
        expectedError = error;
        expectedData = data;
    };
    testDelegate1 = [GGModelControllerTestDelegate new];
    testDelegate1.testBlock = ^(id data, NSError *error) {
        expectedError = error;
        expectedData = data;
    };
    GGRemoteService *service = [[GGRemoteService alloc] initWithURL:[NSURL URLWithString:@"http://some.url.to"] sessionManager:sessionManager];
    modelController = [[GGModelController alloc] initWithService:service];
    [modelController addDelegate:testDelegate];
    [modelController addDelegate:testDelegate1];
    
    beforeEach(^{
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return YES;
        } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
            NSDictionary *headers = @{};
            if (shouldFail) {
                data = nil;
            } else {
                headers = @{@"Content-Type" : @"application/json"};
            }
            return [[OHHTTPStubsResponse responseWithData:data
                                               statusCode:(shouldFail) ? 500 : 200
                                                  headers:headers] responseTime:0];
        }];
    });
    
    afterEach(^{
        [OHHTTPStubs removeAllStubs];
    });
    
    context(@"when calling fetchData and expecting valid results", ^{
        it(@"should call the appropriate methods on all delegates with a nil error and a proper data object", ^{
            [[testDelegate shouldEventually] receive:@selector(modelControllerWillFetchData:) withArguments:modelController];
            [[testDelegate1 shouldEventually] receive:@selector(modelControllerWillFetchData:) withArguments:modelController];
            [[testDelegate shouldEventually] receive:@selector(modelController:didReceiveData:error:) withArguments:modelController, json, nil];
            [[testDelegate1 shouldEventually] receive:@selector(modelController:didReceiveData:error:) withArguments:modelController, json, nil];
            [modelController fetchDataWithRange:NSMakeRange(0, 0)];
        });
    });
    
    context(@"when calling fetchData and expecting invalid results", ^{
        it(@"delegates should receive nil data and a proper error", ^{
            shouldFail = YES;
            [modelController fetchDataWithRange:NSMakeRange(0, 0)];
            [[expectFutureValue(expectedData) shouldEventually] beNil];
            [[expectFutureValue(expectedError) shouldEventually] beNonNil];
        });
    });
    
    
    
});

SPEC_END
