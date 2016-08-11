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

RCT_EXPORT_VIEW_PROPERTY(params, NSDictionary);

@end
