/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  TouchableHighlight,
  NativeModules,
  findNodeHandle,
  Text,
  View
} from 'react-native';

import VideoView from './src/IMAVideoPlayer';
const IMAVideoManager = NativeModules.IMAVideoManager;

class video2 extends Component {

  constructor(props) {
      super(props);
      this._onPressButtonPlay = this._onPressButtonPlay.bind(this);
      this._onPressButtonPause = this._onPressButtonPause.bind(this);
      this._onPlay = this._onPlay.bind(this);
      this._onPause = this._onPause.bind(this);
      this._onComplete = this._onComplete.bind(this);
  }

  render() {
    return (
      <View style={styles.container}>
        <TouchableHighlight onPress={this._onPressButtonPlay}>
        <Text>Play</Text>
      </TouchableHighlight>
      <TouchableHighlight onPress={this._onPressButtonPause}>
        <Text>Pause</Text>
      </TouchableHighlight>
        <VideoView
          onPlay={this._onPlay}
          onPause={this._onPause}
          adTagUrl = 'https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ct%3Dlinear&correlator='
          src = 'http://rmcdn.2mdn.net/Demo/html5/output.mp4'
          paused={false}
          skipAds={false}
          restart={false}
          ref='vid'
          // adUnitId='TEST_ADUNITID'
          // defaultAdUnitId='TEST_DEFAULTADUNITID'
          // live={true}
          // showname='TEST_SHOWNAME'
          // segment='TEST_SEGMENT'
          // targetParams={{'k1' : 'v1'}}
          // adTestNameValuePair={{'k2' : 'v2'}}
          // contentLaunchAdParams={{'k3' : 'v3'}}
          style={styles.video}/>
      </View>
    );
  }

  _onPressButtonPlay() {
    // IMAVideoManager.play(findNodeHandle(this.refs['vid']))
  }

  _onPressButtonPause() {
    // IMAVideoManager.pause(findNodeHandle(this.refs['vid']))
  }

  _onPlay() {
    console.log('ON PLAY!');
  }

  _onPause() {
    console.log('ON PAUSE!');
  }

  _onComplete() {
    console.log('ON COMPLETE!');
  }

}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  video: {
    width: 300,
    height: 200,
    backgroundColor: '#1FBAC3'
  }
});

AppRegistry.registerComponent('video2', () => video2);
