//
//  IMAVideoModule.m
//  video2
//
//  Created by Alexander Perepelitsyn on 7/27/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCTBridgeModule.h"
#import "RCTViewManager.h"

@interface RCT_EXTERN_MODULE(IMAVideoManager, RCTViewManager)

RCT_EXTERN_METHOD(play:(nonnull NSNumber*)reactTag);
RCT_EXTERN_METHOD(pause:(nonnull NSNumber*)reactTag);
RCT_EXTERN_METHOD(resume:(nonnull NSNumber*)reactTag);

RCT_EXPORT_VIEW_PROPERTY(src, NSString);
RCT_EXPORT_VIEW_PROPERTY(adTagUrl, NSString);
RCT_EXPORT_VIEW_PROPERTY(adUnitId, NSString);
RCT_EXPORT_VIEW_PROPERTY(defaultAdUnitId, NSString);
RCT_EXPORT_VIEW_PROPERTY(live, BOOL);
RCT_EXPORT_VIEW_PROPERTY(showname, NSString);
RCT_EXPORT_VIEW_PROPERTY(segment, NSString);
RCT_EXPORT_VIEW_PROPERTY(targetParams, NSDictionary);
RCT_EXPORT_VIEW_PROPERTY(adTestNameValuePair, NSDictionary);
RCT_EXPORT_VIEW_PROPERTY(contentLaunchAdParams, NSDictionary);

@end
