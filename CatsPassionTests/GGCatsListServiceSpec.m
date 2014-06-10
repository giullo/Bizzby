//
//  GGCatsListServiceSpec.m
//  CatsPassion
//
//  Created by giuliano galea on 10/06/2014.
//  Copyright (c) 2014 Giuliano Galea. All rights reserved.
//

#import "Kiwi.h"
#import "GGCatsListService.h"
#import "GGCat.h"
#import <AFNetworking/AFNetworking.h>
#import <OHHTTPStubs/OHHTTPStubs.h>

SPEC_BEGIN(GGCatsListServiceSpec)

describe(@"GGCatsListService", ^{
    
    NSString *catURL0 = @"";
    NSString *catID0 = @"7do";
    NSString *catURL1 = @"";
    NSString *catID1 = @"a8u";
    NSURL *thumbURLURL0 = [NSURL URLWithString:@"http://some.url.to?image_id=7do&size=small"];
    NSURL *thumbURLURL1 = [NSURL URLWithString:@"http://some.url.to?image_id=a8u&size=small"];
    
    NSString *xml = [NSString stringWithFormat:@"<response><data><images><image><url>%@</url><id>%@</id><source_url>http://thecatapi.com/?id=7do</source_url></image><image><url>%@</url><id>%@</id><source_url>http://thecatapi.com/?id=a8u</source_url></image></images></data></response>", catURL0, catID0, catURL1, catID1];
    __block BOOL shouldFail = NO;
    beforeEach(^{
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return YES;
        } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
            NSDictionary *headers = @{};
            NSData *data           = [xml dataUsingEncoding:NSUTF8StringEncoding];
            if (shouldFail) {
                data = nil;
            } else {
                headers = @{@"Content-Type" : @"application/xml"};
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
            sessionManager.responseSerializer = [AFXMLParserResponseSerializer new];
            GGCatsListService *service = [[GGCatsListService alloc] initWithURL:[NSURL URLWithString:@"http://some.url.to"] sessionManager:sessionManager];
            [service fetchDataWithRange:NSMakeRange(0, 0) withCompletionBlock:^(id data, NSError *error) {
                items = data;
                blockError = error;
            }];
            [[expectFutureValue(blockError) shouldEventuallyBeforeTimingOutAfter(3)] beNil];
            [[expectFutureValue(@(items.count)) shouldEventuallyBeforeTimingOutAfter(3)] equal:@(2)];
            [[expectFutureValue([items[0] uniqueId]) shouldEventuallyBeforeTimingOutAfter(3)] equal:catID0];
            [[expectFutureValue([items[1] uniqueId]) shouldEventuallyBeforeTimingOutAfter(3)] equal:catID1];
            [[expectFutureValue([items[0] thumbImageURL]) shouldEventuallyBeforeTimingOutAfter(3)] equal:thumbURLURL0];
            [[expectFutureValue([items[1] thumbImageURL]) shouldEventuallyBeforeTimingOutAfter(3)] equal:thumbURLURL1];
            
        });
    });
});

SPEC_END