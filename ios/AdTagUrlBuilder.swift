//
//  AdTagUrlBuilder.swift
//  video2
//
//  Created by Alexander Perepelitsyn on 7/28/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

import Foundation

protocol AdTagUrlBuilderDelegate: class {
  func adTagBuilder(adTagBuilder: AdTagUrlBuilder, didConstructAdTagUrl adTagUrl: String)
}

class AdTagUrlBuilder {
  
//  var result: String?
  weak var delegate: AdTagUrlBuilderDelegate?
    
  var adUnitId: String? {
    didSet {
      updateAdTagUrl()
    }
  }
  var defaultAdUnitId: String? {
    didSet {
      updateAdTagUrl()
    }
  }
  var live: Bool? {
    didSet {
      updateAdTagUrl()
    }
  }
  var showname: String? {
    didSet {
      updateAdTagUrl()
    }
  }
  var segment: String? {
    didSet {
      updateAdTagUrl()
    }
  }
  var targetParams: [String : AnyObject]? {
    didSet {
      updateAdTagUrl()
    }
  }
  var adTestNameValuePair: [String : AnyObject]? {
    didSet {
      updateAdTagUrl()
    }
  }
  var contentLaunchAdParams: [String : AnyObject]? {
    didSet {
      updateAdTagUrl()
    }
  }
  
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
  
  private func updateAdTagUrl() {
    let result = generateAdTagUrl()
    delegate?.adTagBuilder(self, didConstructAdTagUrl: result)
  }

  private func generateAdTagUrl() -> String {
    var urlTemplate = ""
    
    if let defaultAdUnitId = defaultAdUnitId, adUnitId = adUnitId, live = live, showname = showname {
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
    custParams = custParams.concatWithParams(targetParams)
    
    if let segment = segment {
      if (!segment.isEmpty) {
        custParams = custParams + kAdParamSegment + kCharEquals + segment + kCharAnd
      }
    }
    
    custParams = custParams.concatWithParams(contentLaunchAdParams)
    custParams = custParams.concatWithParams(adTestNameValuePair)
    
    if (custParams.length() > 0) {
      let custParamsUTF8Encoded = custParams.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
      if let custParamsUTF8Encoded = custParamsUTF8Encoded {
        urlTemplate = urlTemplate + kAdTargetQueryParamCustParams + kCharEquals + custParamsUTF8Encoded + kCharAnd
      }
    }
    
    return urlTemplate
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
