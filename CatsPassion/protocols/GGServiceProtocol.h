//
//  GGServiceProtocol.h
//  CatsPassion
//
//  Created by giullo on 05/06/2014.
//  Copyright (c) 2014 Giuliano Galea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef void (^GGServiceProtocolCompletionBlock) (id data, NSError *error);

@protocol GGServiceProtocol <NSObject>

- (instancetype)initWithURL:(NSURL *)url sessionManager:(AFHTTPSessionManager *)sessionManager;
- (void)fetchDataWithRange:(NSRange)range withCompletionBlock:(GGServiceProtocolCompletionBlock)completionBlock;
@property (nonatomic, readonly, strong) NSURL *url;

@end
