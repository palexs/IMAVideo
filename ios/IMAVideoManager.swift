//
//  IMAVideoManager.swift
//  video2
//
//  Created by Alexander Perepelitsyn on 7/27/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

import Foundation

struct Callback {
  static let onPlay = "onPlay"
  static let onPause = "onPause"
  static let onResume = "onResume"
  static let onComplete = "onComplete"
  static let onError = "onError"
  static let onPrerollsFinished = "onPrerollsFinished"
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
      Callback.onResume,
      Callback.onComplete,
      Callback.onError,
      Callback.onPrerollsFinished
    ];
  }
  
// MARK: - Commands received from React Native
  
  @objc func play(reactTag: NSNumber) {
    self.bridge.uiManager.addUIBlock { (uiManager: RCTUIManager!, viewRegistry:[NSNumber : UIView]!) in
      let player: IMAVideoPlayer = viewRegistry[reactTag] as! IMAVideoPlayer;
      player.play();
    }
  }
  
  @objc func pause(reactTag: NSNumber) {
    self.bridge.uiManager.addUIBlock { (uiManager: RCTUIManager!, viewRegistry:[NSNumber : UIView]!) in
      let player: IMAVideoPlayer = viewRegistry[reactTag] as! IMAVideoPlayer;
      player.pause();
    }
  }
  
  @objc func resume(reactTag: NSNumber) {
    self.bridge.uiManager.addUIBlock { (uiManager: RCTUIManager!, viewRegistry:[NSNumber : UIView]!) in
      let player: IMAVideoPlayer = viewRegistry[reactTag] as! IMAVideoPlayer;
      player.resume();
    }
  }
  
}