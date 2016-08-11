//
//  IMAVideoPlayer.swift
//  Pods
//
//  Created by Alexander Perepelitsyn on 7/28/16.
//
//

import Foundation

class IMAVideoPlayer: UIView, VideoPlayerWithAdPlayback {
  
  private var videoPlayerController: VideoPlayerWithAdPlaybackController?
  private var eventDispatcher: RCTEventDispatcher?
  
  private var _params: [String : AnyObject]?
  
  func initWithEventDispatcher(eventDispatcher: RCTEventDispatcher) -> UIView {
    self.eventDispatcher = eventDispatcher
    let adContainer = UIView()
    self.addSubview(adContainer)
    
    self.videoPlayerController = VideoPlayerWithAdPlaybackController(adContainer: adContainer)
    self.videoPlayerController?.delegate = self
    
    return self
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.videoPlayerController!.addPlayerLayerWithBounds(self.bounds)
  }
  
  // MARK: - Props
  
  func setParams(params: [String : AnyObject]) {
    _params = params;
    
    if let src = params["src"] as? String {
      self.videoPlayerController!.setUpContentPlayerWithContentUrl(src)
    }
    
    if let adTagUrl = params["adTagUrl"] as? String {
      self.videoPlayerController!.adTagUrl = adTagUrl
    }
    
    if let paused = params["paused"] as? Bool {
      paused ? self.videoPlayerController!.pause() : self.videoPlayerController!.play();
    }
    
    if let skipAds = params["skipAds"] as? Bool {
      self.videoPlayerController!.skipAds = skipAds
    }
    
    if let restart = params["restart"] as? Bool {
      self.videoPlayerController!.restart = restart
    }
  }
  
  // MARK: - VideoPlayerWithAdPlayback delegate
  
  private func dispatchToRN(event: String, params: [String : AnyObject]?) {
    var mParams: [String : AnyObject] = [:]
    if let params = params {
      mParams = params
    }
    mParams["target"] = self.reactTag
    
    self.eventDispatcher?.sendInputEventWithName(event, body: mParams)
  }
  
  func onPlay() {
    dispatchToRN(Callback.onPlay, params: nil) // TODO: const strings enum
  }
  
  func onPause() {
    dispatchToRN(Callback.onPause, params: nil)
  }
  
  func onLoadAd() {
    dispatchToRN(Callback.onLoadAd, params: nil)
  }
  
  func onLoadVideo() {
    dispatchToRN(Callback.onLoadVideo, params: nil)
  }
  
  func onStartLoadAd() {
    dispatchToRN(Callback.onStartLoadAd, params: nil)
  }
  
  func onStartLoadVideo() {
    dispatchToRN(Callback.onStartLoadVideo, params: nil)
  }
  
  func onResume() {
    dispatchToRN(Callback.onResume, params: nil)
  }
  
  func onComplete() {
    dispatchToRN(Callback.onComplete, params: nil)
  }
  
  func onError() {
    dispatchToRN(Callback.onError, params: nil)
  }
  
  func onPrerollsFinished() {
    dispatchToRN(Callback.onPrerollsFinished, params: nil)
  }
  
  func onProgress() {
    dispatchToRN(Callback.onProgress, params: nil)
  }
  
}
