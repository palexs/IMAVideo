//
//  IMAVideoManager.swift
//  Pods
//
//  Created by Alexander Perepelitsyn on 7/28/16.
//
//

import Foundation

struct Callback {
  static let onPlay = "onPlay"
  static let onPause = "onPause"
  static let onLoadAd = "onLoadAd"
  static let onLoadVideo = "onLoadVideo"
  static let onStartLoadAd = "onStartLoadAd"
  static let onStartLoadVideo = "onStartLoadVideo"
  static let onResume = "onResume"
  static let onComplete = "onComplete"
  static let onError = "onError"
  static let onPrerollsFinished = "onPrerollsFinished"
  static let onProgress = "onProgress"
}

@objc(IMAVideoManager)
class IMAVideoManager : RCTViewManager {
  
  override func view() -> UIView! {
    return IMAVideoPlayer().initWithEventDispatcher(self.bridge.eventDispatcher());
  }
  
  // MARK: - Callbacks exposed to React Native
  
  override func customDirectEventTypes() -> [String]! {
    return [
      Callback.onPlay,
      Callback.onPause,
      Callback.onLoadAd,
      Callback.onLoadVideo,
      Callback.onStartLoadAd,
      Callback.onStartLoadVideo,
      Callback.onResume,
      Callback.onComplete,
      Callback.onError,
      Callback.onPrerollsFinished,
      Callback.onProgress
    ];
  }
  
}
