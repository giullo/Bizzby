//
//  GGCatsListService.h
//  CatsPassion
//
//  Created by giullo on 05/06/2014.
//  Copyright (c) 2014 Giuliano Galea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGServiceProtocol.h"

@interface GGRemoteService : NSObject <GGServiceProtocol>

@property (nonatomic, readonly, strong) NSURL *url;
@property (nonatomic, copy, readonly) GGServiceProtocolCompletionBlock completionBlock;
@property (nonatomic, strong, readonly) AFHTTPSessionManager *sessionManager;

/* 
    default implementation just calls the completionBlock with data and error
    received from the network response.
    subclasses can override to perform additional validation/parsing and then call super
 */

- (void)processResponseData:(id)response error:(NSError *)error;


@end
