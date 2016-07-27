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
  
  private let kCharEquals = "="
  private let kCharAnd = "&"
  private let kSize = "1x7"
  private let kAdUnitIdLive = "/video/live"
  private let kAdUnitIdVideo = "/video/vod"
  private let kDefaultAdUnitId = "/5262/app/bloomberg"
  private let kAdParamSegment = "ksg"
  private let kAdTargetQueryParamCustParams = "cust_params"
  private let kAdUrlBase = "http://pubads.g.doubleclick.net/gampad/ads"
  private let kAdUrlConstParams = "&impl=s&gdfp_req=1&env=vp&output=xml_vast3&unviewed_position_start=1"
  
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
    updateAdTagUrl()
  }
  
  func setDefaultAdUnitId(defaultAdUnitId: String) {
    _defaultAdUnitId = defaultAdUnitId
    updateAdTagUrl()
  }
  
  func setLive(live: Bool) {
    _live = live
    updateAdTagUrl()
  }
  
  func setShowname(showname: String) {
    _showname = showname
    updateAdTagUrl()
  }
  
  func setSegment(segment: String) {
    _segment = segment
    updateAdTagUrl()
  }
  
  func setTargetParams(targetParams: [String : AnyObject]) {
    _targetParams = targetParams
    updateAdTagUrl()
  }
  
  func setAdTestNameValuePair(adTestNameValuePair: [String : AnyObject]) {
    _adTestNameValuePair = adTestNameValuePair
    updateAdTagUrl()
  }
  
  func setContentLaunchAdParams(contentLaunchAdParams: [String : AnyObject]) {
    _contentLaunchAdParams = contentLaunchAdParams
    updateAdTagUrl()
  }
  
// MARK: - AdTagUrl construction
  
  private func updateAdTagUrl() {
    _adTagUrl = generateAdTagUrl()
    self.videoPlayerController!.adTagUrl = _adTagUrl
  }
  
  private func generateAdTagUrl() -> String {
    var urlTemplate = ""
    
    if let defaultAdUnitId = _defaultAdUnitId, adUnitId = _adUnitId, live = _live, showname = _showname {
      var iu = defaultAdUnitId.isEmpty ? kDefaultAdUnitId : defaultAdUnitId
      if (adUnitId.isEmpty) {
        iu = iu + (live ? kAdUnitIdLive : kAdUnitIdVideo + showname)
      } else {
        iu = adUnitId
      }
      let timestamp = Int64(NSDate().timeIntervalSince1970 * 1000.0)
      urlTemplate = "\(kAdUrlBase)?sz=\(kSize)&iu=\(iu)\(kAdUrlConstParams)&correlator=\(timestamp)&"
    }
    
    var custParams = ""
    custParams = custParams.concatWithParams(_targetParams)
    
    if let segment = _segment {
      if (!segment.isEmpty) {
        custParams = custParams + kAdParamSegment + kCharEquals + segment + kCharAnd
      }
    }
    
    custParams = custParams.concatWithParams(_contentLaunchAdParams)
    custParams = custParams.concatWithParams(_adTestNameValuePair)
    
    if (custParams.length() > 0) {
      let custParamsUTF8Encoded = custParams.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
      if let custParamsUTF8Encoded = custParamsUTF8Encoded {
        urlTemplate = urlTemplate + kAdTargetQueryParamCustParams + kCharEquals + custParamsUTF8Encoded + kCharAnd
      }
    }
    
    return urlTemplate
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

extension String {
  
  mutating func concatWithParams(params:Dictionary<String, AnyObject>?) -> String {
    guard let params = params else {
      return self
    }
    
    for (key, value) in params {
      self = self + key + "=" + (value as! String) + "&"
    }
    
    return self
  }
  
  func length() -> Int {
    return characters.count
  }
  
}