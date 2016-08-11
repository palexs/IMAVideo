import { PropTypes } from 'react';
import {
  requireNativeComponent,
  View,
} from 'react-native';

const iface = {
  name: 'IMAVideo',
  propTypes: {
    params: PropTypes.object,
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
    onProgress: PropTypes.func,
    ...View.propTypes,
  },
};

module.exports = requireNativeComponent('IMAVideo', iface);
