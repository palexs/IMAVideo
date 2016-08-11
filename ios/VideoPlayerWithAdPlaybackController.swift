//
//  VideoPlayerWithAdPlaybackController.swift
//  Pods
//
//  Created by Alexander Perepelitsyn on 7/28/16.
//
//

import Foundation

import AVFoundation
import GoogleInteractiveMediaAds
import UIKit

protocol VideoPlayerWithAdPlayback: class {
  func onPlay()
  func onPause()
  func onLoadAd()
  func onLoadVideo()
  func onStartLoadAd()
  func onStartLoadVideo()
  func onResume()
  func onComplete()
  func onError()
  func onPrerollsFinished()
}

protocol IMAPlayer: class {
  func play()
  func pause()
  func resume()
}

class VideoPlayerWithAdPlaybackController: NSObject, IMAAdsLoaderDelegate, IMAAdsManagerDelegate, IMAPlayer {
  
  private var contentPlayer: AVPlayer?
  private var playerLayer: AVPlayerLayer?
  private var contentPlayhead: IMAAVPlayerContentPlayhead?
  private var adsLoader: IMAAdsLoader!
  private var adsManager: IMAAdsManager!
  
  var adContainer: UIView!
  var src: String?
  var adTagUrl: String?
  var paused: Bool?
  var skipAds: Bool?
  var restart: Bool?
  
  weak var delegate: VideoPlayerWithAdPlayback?
  
  init(adContainer: UIView) {
    super.init()
    
    self.adContainer = adContainer
    setUpAdsLoader()
  }
  
  func setUpContentPlayerWithContentUrl(contentUrl: String) {
    src = contentUrl;
    // Load AVPlayer with path to content.
    guard let contentURL = NSURL(string: contentUrl) else {
      print("ERROR: please use a valid URL for the content URL")
      return
    }
    contentPlayer = AVPlayer(URL: contentURL)
    
    // Set up our content playhead and contentComplete callback.
    contentPlayhead = IMAAVPlayerContentPlayhead(AVPlayer: contentPlayer)
    NSNotificationCenter.defaultCenter().addObserver(
      self,
      selector: #selector(VideoPlayerWithAdPlaybackController.contentDidFinishPlaying(_:)),
      name: AVPlayerItemDidPlayToEndTimeNotification,
      object: contentPlayer?.currentItem);
  }
  
  func addPlayerLayerWithBounds(bounds: CGRect) {
    // Set proper bounds.
    adContainer.frame = bounds
    
    // Create a player layer for the player.
    playerLayer = AVPlayerLayer(player: contentPlayer)
    
    // Size, position, and display the AVPlayer.
    playerLayer?.frame = adContainer.layer.bounds
    adContainer.layer.addSublayer(playerLayer!)
  }
  
  func contentDidFinishPlaying(notification: NSNotification) {
    // Make sure we don't call contentComplete as a result of an ad completing.
    if (notification.object as! AVPlayerItem) == contentPlayer?.currentItem {
      adsLoader.contentComplete()
    }
  }
  
  private func setUpAdsLoader() {
    adsLoader = IMAAdsLoader(settings: nil)
    adsLoader.delegate = self
  }
  
  private func requestAds() {
    // Create ad display container for ad rendering.
    let adDisplayContainer = IMAAdDisplayContainer(adContainer: adContainer, companionSlots: nil)
    // Create an ad request with our ad tag, display container, and optional user context.
    let request = IMAAdsRequest(
      adTagUrl: adTagUrl!,
      adDisplayContainer: adDisplayContainer,
      contentPlayhead: contentPlayhead,
      userContext: nil)
    
    adsLoader.requestAdsWithRequest(request)
    delegate?.onStartLoadAd()
  }
  
  // MARK: - IMAAdsLoaderDelegate
  
  func adsLoader(loader: IMAAdsLoader!, adsLoadedWithData adsLoadedData: IMAAdsLoadedData!) {
    // Grab the instance of the IMAAdsManager and set ourselves as the delegate.
    adsManager = adsLoadedData.adsManager
    adsManager.delegate = self
    
    // Create ads rendering settings and tell the SDK to use the in-app browser.
    let adsRenderingSettings = IMAAdsRenderingSettings()
    adsRenderingSettings.webOpenerPresentingController = nil // Use Safari
    
    // Initialize the ads manager.
    adsManager.initializeWithAdsRenderingSettings(adsRenderingSettings)
  }
  
  func adsLoader(loader: IMAAdsLoader!, failedWithErrorData adErrorData: IMAAdLoadingErrorData!) {
    print("Error loading ads: \(adErrorData.adError.message)")
    contentPlayer?.play()
  }
  
  // MARK: - IMAAdsManagerDelegate
  
  func adsManager(adsManager: IMAAdsManager!, didReceiveAdEvent event: IMAAdEvent!) {
    if event.type == IMAAdEventType.LOADED {
      // When the SDK notifies us that ads have been loaded, play them.
      delegate?.onLoadAd()
      adsManager.start()
    } else if event.type == IMAAdEventType.STARTED {
      delegate?.onPlay()
    } else if event.type == IMAAdEventType.PAUSE {
      delegate?.onPause()
    } else if event.type == IMAAdEventType.RESUME {
      delegate?.onResume()
    } else if event.type == IMAAdEventType.COMPLETE {
      delegate?.onComplete()
    } else if event.type == IMAAdEventType.ALL_ADS_COMPLETED {
      delegate?.onPrerollsFinished()
    }
  }
  
  func adsManager(adsManager: IMAAdsManager!, didReceiveAdError error: IMAAdError!) {
    // Something went wrong with the ads manager after ads were loaded. Log the error and play the
    // content.
    print("AdsManager error: \(error.message)")
    delegate?.onError()
    contentPlayer?.play()
  }
  
  func adsManagerDidRequestContentPause(adsManager: IMAAdsManager!) {
    // The SDK is going to play ads, so pause the content.
    contentPlayer?.pause()
  }
  
  func adsManagerDidRequestContentResume(adsManager: IMAAdsManager!) {
    // The SDK is done playing ads (at least for now), so resume the content.
    contentPlayer?.play()
  }
  
  // MARK: - IMAPlayer
  
  func play() {
    requestAds()
    //    contentPlayer?.play()
  }
  
  func pause() {
    contentPlayer?.pause()
  }
  
  func resume() {
    contentPlayer?.play()
  }
  
}
