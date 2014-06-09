//
//  GGModelControllerProtocol.h
//  CatsPassion
//
//  Created by giullo on 05/06/2014.
//  Copyright (c) 2014 Giuliano Galea. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GGModelControllerDelegate;
@protocol GGServiceProtocol;

@protocol GGModelControllerProtocol <NSObject>

@required
- (instancetype)initWithService:(id <GGServiceProtocol>)service;
- (void)fetchDataWithRange:(NSRange)range;
- (void)addDelegate:(id <GGModelControllerDelegate>)delegate;
- (void)removeDelegate:(id <GGModelControllerDelegate>)delegate;
- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end


@protocol GGModelControllerDelegate <NSObject>

@required
- (void)modelController:(id <GGModelControllerProtocol>)modelCtrl didReceiveData:(id)data error:(NSError *)error;
- (void)modelControllerWillFetchData:(id <GGModelControllerProtocol>)modelCtrl;

@end