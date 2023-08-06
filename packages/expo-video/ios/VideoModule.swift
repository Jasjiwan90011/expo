// Copyright 2023-present 650 Industries. All rights reserved.

import ExpoModulesCore

public final class VideoModule: Module {
  public func definition() -> ModuleDefinition {
    Name("ExpoVideo")

    View(VideoView.self) {
      Prop("player") { (view, player: VideoPlayer) in
        view.player = player.pointer
      }

      Prop("nativeControls") { (view, nativeControls: Bool?) in
        view.playerViewController.showsPlaybackControls = nativeControls ?? true
      }

      Prop("contentFit") { (view, contentFit: VideoContentFit?) in
        view.playerViewController.videoGravity = contentFit?.toVideoGravity() ?? .resizeAspect
      }

      Prop("contentPosition") { (view, contentPosition: CGVector?) in
        let layer = view.playerViewController.view.layer

        layer.frame = CGRect(
          x: contentPosition?.dx ?? 0,
          y: contentPosition?.dy ?? 0,
          width: layer.frame.width,
          height: layer.frame.height
        )
      }

      Prop("fullscreen") { (view, fullscreen: Bool?) in
        if fullscreen == true && !view.isFullscreen {
          view.enterFullscreen()
        } else if fullscreen == false && view.isFullscreen {
          view.exitFullscreen()
        }
      }

      Prop("allowsFullscreen") { (view, allowsFullscreen: Bool?) in
        view.playerViewController.setValue(allowsFullscreen ?? true, forKey: "allowsEnteringFullScreen")
      }

      Prop("canControlPlayback") { (view, canControlPlayback: Bool?) in
//        let selector = NSSelectorFromString("setCanHidePlaybackControls:")
//        view.playerViewController.perform(selector, with: canControlPlayback ?? true)
//        view.playerViewController.setValue(canControlPlayback ?? true, forKey: "canControlPlayback")
      }

      Prop("volumeControls") { (view, showsVolumeControls: Bool?) in
        let selector = NSSelectorFromString("setPlaybackControlsIncludeVolumeControls:")
        view.playerViewController.perform(selector, with: showsVolumeControls ?? true)
//        view.playerViewController.setValue(showsVolumeControls ?? true, forKey: "playbackControlsIncludeVolumeControls")
      }

      Prop("showsTimecodes") { (view, showsTimecodes: Bool?) in
        view.playerViewController.showsTimecodes = showsTimecodes ?? true
      }

      Prop("requiresLinearPlayback") { (view, requiresLinearPlayback: Bool?) in
        view.playerViewController.requiresLinearPlayback = requiresLinearPlayback ?? false
      }

      AsyncFunction("enterFullscreen") { view in
        view.enterFullscreen()
      }

      AsyncFunction("exitFullscreen") { view in
        view.exitFullscreen()
      }
    }

    Class(VideoPlayer.self) {
      Constructor { (source: String?) -> VideoPlayer in
        if let source, let url = URL(string: source) {
          let item = AVPlayerItem(url: url)
          return VideoPlayer(AVPlayer(playerItem: item))
        }
        return VideoPlayer(AVPlayer())
      }

      Property("isPlaying") { (player: VideoPlayer) in
        return player.pointer.timeControlStatus == .playing
      }

      Function("play") { player in
        player.pointer.play()
      }

      Function("pause") { player in
        player.pointer.pause()
      }

      Function("replace") { (player, source: String) in
        guard let url = URL(string: source) else {
          player.pointer.replaceCurrentItem(with: nil)
          return
        }
        let newPlayerItem = AVPlayerItem(url: url)

        player.pointer.replaceCurrentItem(with: newPlayerItem)
        player.pointer.play()
      }
    }

    Class(VideoItem.self) {
      Constructor { (url: URL) in
        return VideoItem(url: url)
      }

      Property("duration", \.playerItem.asset.duration.seconds)

      Property("currentTime") { item in
        return item.playerItem.currentTime().seconds
      }
    }
  }
}

internal final class VideoPlayer: SharedRef<AVPlayer> {}

internal final class VideoItem: SharedObject {
  let playerItem: AVPlayerItem

  init(url: URL) {
    playerItem = AVPlayerItem(url: url)
  }
}
