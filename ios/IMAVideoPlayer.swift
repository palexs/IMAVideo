//
//  IMAVideoPlayer.swift
//  video2
//
//  Created by Alexander Perepelitsyn on 7/27/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

import Foundation

class IMAVideoPlayer: UIView, VideoPlayerWithAdPlayback {
  
  private var videoPlayerController: VideoPlayerWithAdPlaybackController?
  private var eventDispatcher: RCTEventDispatcher?
  private var adTagUrlBuilder: AdTagUrlBuilder = AdTagUrlBuilder()
  
  private var _src: String?
  private var _adTagUrl: String?
  private var _adUnitId: String?
  private var _defaultAdUnitId: String?
  private var _live: Bool?
  private var _showname: String?
  private var _segment: String?
  private var _targetParams: [String : AnyObject]?
  private var _adTestNameValuePair: [String : AnyObject]?
  private var _contentLaunchAdParams: [String : AnyObject]?
  
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
  
  func setSrc(src: String) {
    _src = src
    self.videoPlayerController!.setUpContentPlayerWithContentUrl(src)
  }
  
  func setAdTagUrl(adTagUrl: String) {
    _adTagUrl = adTagUrl
    self.videoPlayerController!.adTagUrl = adTagUrl
  }
  
  func setAdUnitId(adUnitId: String) {
    _adUnitId = adUnitId
    adTagUrlBuilder.adUnitId = adUnitId
    self.videoPlayerController!.adTagUrl = adTagUrlBuilder.result
  }
  
  func setDefaultAdUnitId(defaultAdUnitId: String) {
    _defaultAdUnitId = defaultAdUnitId
    adTagUrlBuilder.defaultAdUnitId = defaultAdUnitId
    self.videoPlayerController!.adTagUrl = adTagUrlBuilder.result
  }
  
  func setLive(live: Bool) {
    _live = live
    adTagUrlBuilder.live = live
    self.videoPlayerController!.adTagUrl = adTagUrlBuilder.result
  }
  
  func setShowname(showname: String) {
    _showname = showname
    adTagUrlBuilder.showname = showname
    self.videoPlayerController!.adTagUrl = adTagUrlBuilder.result
  }
  
  func setSegment(segment: String) {
    _segment = segment
    adTagUrlBuilder.segment = segment
    self.videoPlayerController!.adTagUrl = adTagUrlBuilder.result
  }
  
  func setTargetParams(targetParams: [String : AnyObject]) {
    _targetParams = targetParams
    adTagUrlBuilder.targetParams = targetParams
    self.videoPlayerController!.adTagUrl = adTagUrlBuilder.result
  }
  
  func setAdTestNameValuePair(adTestNameValuePair: [String : AnyObject]) {
    _adTestNameValuePair = adTestNameValuePair
    adTagUrlBuilder.adTestNameValuePair = adTestNameValuePair
    self.videoPlayerController!.adTagUrl = adTagUrlBuilder.result
  }
  
  func setContentLaunchAdParams(contentLaunchAdParams: [String : AnyObject]) {
    _contentLaunchAdParams = contentLaunchAdParams
    adTagUrlBuilder.contentLaunchAdParams = contentLaunchAdParams
    self.videoPlayerController!.adTagUrl = adTagUrlBuilder.result
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
  
// MARK: -
  
  func play() {
    self.videoPlayerController!.play()
  }
  
  func pause() {
    self.videoPlayerController!.pause()
  }
  
  func resume() {
    self.videoPlayerController!.resume()
  }
  
}
