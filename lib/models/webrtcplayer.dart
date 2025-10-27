import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;

class WebRTCPlayer {
  void Function(webrtc.MediaStream)? _onRemoteStream;
  webrtc.RTCPeerConnection? _pc;

  /// When got a remote stream.
  set onRemoteStream(void Function(webrtc.MediaStream) v) {
    _onRemoteStream = v;
  }

  /// Initialize the player.
  void initState() {}

  /// Start play a url.
  /// [url] must a path parsed by [WebRTCUri.parse] in https://github.com/rtcdn/rtcdn-draft
  Future<void> play(String url) async {
    if (_pc != null) {
      await _pc?.close();
    }

    // Create the peer connection.
    _pc = await webrtc.createPeerConnection({
      // AddTransceiver is only available with Unified Plan SdpSemantics
      'sdpSemantics': "unified-plan",
    });

    debugPrint('WebRTC: createPeerConnection done');

    // Setup the peer connection.
    _pc?.onAddStream = (webrtc.MediaStream stream) {
      debugPrint('WebRTC: got stream ${stream.id}');
      if (_onRemoteStream == null) {
        debugPrint('Warning: Stream ${stream.id} is leak');
        return;
      }
      _onRemoteStream?.call(stream);
    };

    _pc?.addTransceiver(
      kind: webrtc.RTCRtpMediaType.RTCRtpMediaTypeAudio,
      init: webrtc.RTCRtpTransceiverInit(direction: webrtc.TransceiverDirection.RecvOnly),
    );
    _pc?.addTransceiver(
      kind: webrtc.RTCRtpMediaType.RTCRtpMediaTypeVideo,
      init: webrtc.RTCRtpTransceiverInit(direction: webrtc.TransceiverDirection.RecvOnly),
    );
    debugPrint('WebRTC: Setup PC done, A|V RecvOnly');

    // Start SDP handshake.
    webrtc.RTCSessionDescription offer = await _pc!.createOffer({
      'mandatory': {'OfferToReceiveAudio': true, 'OfferToReceiveVideo': true},
    });
    await _pc?.setLocalDescription(offer);
    debugPrint(
      'WebRTC: createOffer, ${offer.type} is ${offer.sdp?.replaceAll('\n', '\\n').replaceAll('\r', '\\r')}',
    );

    webrtc.RTCSessionDescription answer = await _handshake(url, offer.sdp ?? '');
    debugPrint(
      'WebRTC: got ${answer.type} is ${answer.sdp?.replaceAll('\n', '\\n').replaceAll('\r', '\\r')}',
    );

    await _pc?.setRemoteDescription(answer);
  }

  /// Handshake to exchange SDP, send offer and got answer.
  Future<webrtc.RTCSessionDescription> _handshake(String url, String offer) async {
    // Setup the client for HTTP or HTTPS.
    HttpClient client = HttpClient();

    try {
      // Allow self-sign certificate, see https://api.flutter.dev/flutter/dart-io/HttpClient/badCertificateCallback.html
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;

      // Parsing the WebRTC uri form url.
      WebRTCUri uri = WebRTCUri.parse(url);

      // Do signaling for WebRTC.
      // @see https://github.com/rtcdn/rtcdn-draft
      //
      // POST http://d.ossrs.net:11985/rtc/v1/play/
      //    {api: "xxx", sdp: "offer", streamurl: "webrtc://d.ossrs.net:11985/live/livestream"}
      // Response:
      //    {code: 0, sdp: "answer", sessionid: "007r51l7:X2Lv"}
      HttpClientRequest req = await client.postUrl(Uri.parse(uri.api));
      req.headers.set('Content-Type', 'application/json');
      req.add(utf8.encode(json.encode({'api': uri.api, 'streamurl': uri.streamUrl, 'sdp': offer})));
      debugPrint('WebRTC request: ${uri.api} offer=${offer.length}B');

      HttpClientResponse res = await req.close();
      String reply = await res.transform(utf8.decoder).join();
      debugPrint('WebRTC reply: ${reply.length}B, ${res.statusCode}');

      Map<String, dynamic> o = json.decode(reply);
      if (!o.containsKey('code') || !o.containsKey('sdp') || o['code'] != 0) {
        return Future.error(reply);
      }

      return Future.value(webrtc.RTCSessionDescription(o['sdp'], 'answer'));
    } catch (e) {
      client.close();
      return Future.error(e);
    } finally {
      client.close();
    }
  }

  /// Dispose the player.
  void dispose() {
    if (_pc != null) {
      _pc?.close();
    }
  }
}

/// The uri for webrtc, for example, [FlutterLive.rtc]:
///   webrtc://d.ossrs.net:11985/live/livestream
/// is parsed as a WebRTCUri:
///   api: http://d.ossrs.net:11985/rtc/v1/play/
///   streamUrl: "webrtc://d.ossrs.net:11985/live/livestream"
class WebRTCUri {
  /// The api server url for WebRTC streaming.
  late String api;

  /// The stream url to play or publish.
  late String streamUrl;

  /// Parse the url to WebRTC uri.
  static WebRTCUri parse(String url, {bool isStream = false}) {
    Uri uri = Uri.parse(url);

    String? schema = 'https'; // For native, default to HTTPS
    if (uri.queryParameters.containsKey('schema')) {
      schema = uri.queryParameters['schema'];
    } else {
      schema = 'https';
    }

    var port = (uri.port > 0) ? uri.port : 443;
    if (schema == 'https') {
      port = (uri.port > 0) ? uri.port : 443;
    } else if (schema == 'http') {
      port = (uri.port > 0) ? uri.port : 1985;
    }

    String? api = isStream ? '/rtc/v1/publish/' : '/rtc/v1/play/';
    if (uri.queryParameters.containsKey('play')) {
      api = uri.queryParameters['play'];
    }

    var apiParams = [];
    for (var key in uri.queryParameters.keys) {
      if (key != 'api' && key != 'play' && key != 'schema') {
        apiParams.add('$key=${uri.queryParameters[key]}');
      }
    }

    var apiUrl = '$schema://${uri.host}:$port$api';
    if (apiParams.isNotEmpty) {
      apiUrl += '?${apiParams.join('&')}';
    }

    WebRTCUri r = WebRTCUri();
    r.api = apiUrl;
    r.streamUrl = url;
    debugPrint('Url $url parsed to api=${r.api}, stream=${r.streamUrl}');
    return r;
  }
}
