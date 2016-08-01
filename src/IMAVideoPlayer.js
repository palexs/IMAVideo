import React, {
  PropTypes,
  Component,
} from 'react';
import {
  View,
} from 'react-native';

import IMAVideo from './IMAVideo';

const CHAR_EQUALS = "="
const CHAR_AND = "&"
const SIZE = "1x7"
const AD_UNIT_ID_LIVE = "/video/live"
const AD_UNIT_ID_VIDEO = "/video/vod"
const DEFAULT_AD_UNIT_ID = "/5262/app/bloomberg"
const AD_PARAM_SEGMENT = "ksg"
const AD_TARGET_QUERY_PARAM_CUST_PARAMS = "cust_params"
const AD_URL_BASE = "http://pubads.g.doubleclick.net/gampad/ads"
const AD_URL_CONST_PARAMS = "&impl=s&gdfp_req=1&env=vp&output=xml_vast3&unviewed_position_start=1"

class IMAVideoPlayer extends Component {

  static propTypes = {
    ...View.propTypes,
    src: PropTypes.string,
    adTagUrl: PropTypes.string,
    adUnitId: PropTypes.string,
    defaultAdUnitId: PropTypes.string,
    live: PropTypes.bool,
    showname: PropTypes.string,
    segment: PropTypes.string,
    targetParams: PropTypes.object,
    adTestNameValuePair: PropTypes.object,
    contentLaunchAdParams: PropTypes.object,
    onPlay: PropTypes.func,
    onPause: PropTypes.func,
    onLoadAd: PropTypes.func,
    onLoadVideo: PropTypes.func,
    onStartLoadAd: PropTypes.func,
    onStartLoadVideo: PropTypes.func,
    onResume: PropTypes.func,
    onComplete: PropTypes.func,
    onError: PropTypes.func,
    onPrerollsFinished: PropTypes.func,
  };

  constructor(props) {
    super(props);
    this.state = props;
  }

  // componentWillReceiveProps(nextProps) {
  //   this.setState(nextProps);
  // }

  generateAdTagUrl() {
    var urlTemplate = ""
    var iu = this.state.defaultAdUnitId ? this.state.defaultAdUnitId : DEFAULT_AD_UNIT_ID
    if (!this.state.adUnitId) {
      iu = iu + (this.state.live ? AD_UNIT_ID_LIVE : AD_UNIT_ID_VIDEO + this.state.showname)
    } else {
      iu = this.state.adUnitId
    }

    const timestamp = new Date().getTime(); // number of milliseconds since 1970/01/01
    urlTemplate = `${AD_URL_BASE}?sz=${SIZE}&iu=${iu}${AD_URL_CONST_PARAMS}&correlator=${timestamp}${CHAR_AND}`

    var custParams = ""
    custParams = this.concatStringWithParams(custParams, this.state.targetParams)

    if (this.state.segment) {
      custParams = custParams + AD_PARAM_SEGMENT + CHAR_EQUALS + this.state.segment + CHAR_AND
    }

    custParams = this.concatStringWithParams(custParams, this.state.contentLaunchAdParams)
    custParams = this.concatStringWithParams(custParams, this.state.adTestNameValuePair)

    if (custParams.length > 0) {
      const custParamsUTF8Encoded = unescape(encodeURIComponent(custParams))
      urlTemplate = urlTemplate + AD_TARGET_QUERY_PARAM_CUST_PARAMS + CHAR_EQUALS + custParamsUTF8Encoded + CHAR_AND
    }

    return urlTemplate
  }

  concatStringWithParams(str, params) {
    var result = ""
    if (!params) {
      return this
    }

    for(var key in params) {
      var value = params[key]
      result = `${str}${key}=${value}&`
    }

    return result
  }

  render() {
    return (
        <IMAVideo src = {this.state.src}
        adTagUrl = {this.state.adTagUrl ? this.state.adTagUrl : this.generateAdTagUrl()}
        onPlay = {this.state.onPlay}
        onPause = {this.state.onPause}
        onLoadAd = {this.state.onLoadAd}
        onLoadVideo = {this.state.onLoadVideo}
        onStartLoadAd = {this.state.onStartLoadAd}
        onStartLoadVideo = {this.state.onStartLoadVideo}
        onResume = {this.state.onResume}
        onComplete = {this.state.onComplete}
        onError = {this.state.onError}
        onPrerollsFinished = {this.state.onPrerollsFinished}
        style = {this.state.style}/>
    );
  }
}

module.exports = IMAVideoPlayer;
