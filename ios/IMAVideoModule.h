//
//  IMAVideoModule.h
//  video2
//
//  Created by Alexander Perepelitsyn on 7/27/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "RCTView.h"

@interface IMAVideoManager: RCTView

@property (nonatomic, copy) NSString* src;
@property (nonatomic, copy) NSString* adTagUrl;
@property (nonatomic, copy) NSString* adUnitId;
@property (nonatomic, copy) NSString* defaultAdUnitId;
@property (nonatomic, assign) BOOL live;
@property (nonatomic, copy) NSString* showname;
@property (nonatomic, copy) NSString* segment;
@property (nonatomic, copy) NSDictionary* targetParams;
@property (nonatomic, copy) NSDictionary* adTestNameValuePair;
@property (nonatomic, copy) NSDictionary* contentLaunchAdParams;

@end
