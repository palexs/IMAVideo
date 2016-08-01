import { PropTypes } from 'react';
import {
  requireNativeComponent,
  View,
} from 'react-native';

const iface = {
  name: 'IMAVideo',
  propTypes: {
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
    ...View.propTypes,
  },
};

module.exports = requireNativeComponent('IMAVideo', iface);
