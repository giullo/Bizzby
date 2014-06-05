//
//  GGModelController.m
//  CatsPassion
//
//  Created by giullo on 05/06/2014.
//  Copyright (c) 2014 Giuliano Galea. All rights reserved.
//

#import "GGModelController.h"
#import "GGServiceProtocol.h"

@interface GGModelController ()

@property (nonatomic, strong) NSPointerArray *delegates;
@property (nonatomic, strong) id <GGServiceProtocol> service;
@end

@implementation GGModelController

#pragma mark - Init

- (instancetype)initWithService:(id<GGServiceProtocol>)service
{
    NSParameterAssert(service);
    self = [super init];
    if (self) {
        _delegates = [[NSPointerArray alloc] initWithOptions:NSPointerFunctionsWeakMemory];
        _service = service;
    }
    return self;
}

- (instancetype)init
{
    NSAssert(NO, @"Please use initWithService");
    return nil;
}

- (void)addDelegate:(id<GGModelControllerDelegate>)delegate
{
    NSParameterAssert(delegate);
    [self.delegates addPointer:(void *)delegate];
}

- (void)removeDelegate:(id<GGModelControllerDelegate>)delegate
{
    NSParameterAssert(delegate);
    NSUInteger index = NSUIntegerMax;
    NSUInteger position = 0;
    for (id item in self.delegates) {
        if (item == delegate) {
            index = position;
            break;
        }
        position++;
    }
    if (index != NSUIntegerMax) {
        [self.delegates removePointerAtIndex:index];
    }
}

- (void)fetchDataWithRange:(NSRange)range {
    for (id <GGModelControllerDelegate> delegate in self.delegates) {
        [delegate modelControllerWillFetchData:self];
    }
    
    [self.service fetchDataWithRange:range withCompletionBlock:^(id data, NSError *error) {
        for (id <GGModelControllerDelegate> delegate in self.delegates) {
            [delegate modelController:self didReceiveData:data error:error];
        }
    }];
};

@end
