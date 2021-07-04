//
//  PlayerView.swift
//  ApplePodcastClone
//
//  Created by Rishabh Dubey on 13/06/21.
//

import UIKit
import AVKit

class PlayerView: UIView {
    
    //MARK: - Property Injection
    var episode: Episode! {
        didSet {
            episodeImageView.sd_setImage(with: episode.episodeUrl)
            titleLabel.text = episode.title
            authorLabel.text = episode.author
            
            miniEpisodeImageView.sd_setImage(with: episode.episodeUrl)
            miniTitleLabel.text = episode.title
            
            // Play the episode after getting the data.
            playEpisode()
        }
    }
    
    //MARK: - View Properties
    let dismissButton = UIButton(title: "Dismiss", font: .boldSystemFont(ofSize: 16))
    let episodeImageView = UIImageView(cornerRadius: 12, contentMode: .scaleAspectFit)
    let startTimeLabel = UILabel(text: "0:00", font: .boldSystemFont(ofSize: 14), textColor: .lightGray)
    let endTimeLabel = UILabel(text: "--:--", font: .boldSystemFont(ofSize: 14), textColor: .lightGray)
    let titleLabel = UILabel(text: "NA", font: .boldSystemFont(ofSize: 18), numberOfLines: 2)
    let authorLabel = UILabel(text: "NA", font: .boldSystemFont(ofSize: 16), textColor: .systemPurple)
    let playbackSlider = UISlider()
    let volumeSlider = UISlider()
    
    let rewindButton = setCustomButton(imageName: "gobackward.15")
//    let playPauseButton = setCustomButton(imageName: "pause.fill", size: 40, scale: .large)//pause.fill play.fill
    let fastForwardButton = setCustomButton(imageName: "goforward.15")
    
    let playPauseButton: UIButton = {
        let button = UIButton(type: .system)
        let systemImage = UIImage.systemImage(imageName: "pause.fill", size: 40, weight: .regular, scale: .large)
        button.setImage(systemImage, for: .normal)
        return button
    }()
    
    let noVolumeImageView = UIImageView(image: .systemImage(imageName: "speaker.fill", color: .gray, size: 12, weight: .light, scale: .small))
    let volumeImageView = UIImageView(image: .systemImage(imageName: "speaker.wave.3.fill", color: .gray, size: 12, weight: .light, scale: .small))
    
    //MARK: - Helper Functions
    static func setCustomButton(imageName: String, size: CGFloat = 32, scale: UIImage.SymbolScale = .medium) -> UIButton {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: size, weight: .regular, scale: scale)
        let systemImage = UIImage(systemName: imageName, withConfiguration: config)?.withTintColor(.black, renderingMode: .alwaysOriginal)
        button.setImage(systemImage, for: .normal)
        return button
    }
    
    //MARK: - AVPlayer
    var player: AVPlayer = {
        let player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = false
        return player
    }()
    
    var maximizedStackView: UIStackView!
    
    let miniPlayerView = UIView(backgroundColor: .systemGray6)
    let miniEpisodeImageView = UIImageView(cornerRadius: 6, contentMode: .scaleAspectFit)
    let miniTitleLabel = UILabel(text: "NA", font: .systemFont(ofSize: 16))
    
    let miniPlayPauseButton: UIButton = {
        let button = UIButton(type: .system)
        let systemImage = UIImage.systemImage(imageName: "pause.fill", size: 22, weight: .regular, scale: .large)
        button.setImage(systemImage, for: .normal)
        return button
    }()
    
    let miniFastForwardButton = setCustomButton(imageName: "goforward.15", size: 20)
    
    var panGesture: UIPanGestureRecognizer!
    
    //MARK: - View Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupGestures()
        
        self.episodeImageView.transform = shrunkenTransform
        
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.animateEpisodeImageView()
        }
        
        observePlayerCurrentTime()
        
        backgroundColor = .white
        setupPlayerView()
        setupMiniPlayerView()
        setActions()
    }
    
    fileprivate func setupGestures() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximize)))
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
    }
    
    @objc func handleTapMaximize() {
        let mainTabBarController = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController as? MainTabBarController
        mainTabBarController?.maximizePlayer(episode: nil)
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            break
        case .changed:
            let yTranslation = gesture.translation(in: superview).y
            self.transform = .init(translationX: 0, y: yTranslation)
            
            self.miniPlayerView.alpha = 1 + yTranslation/200
            
        case .ended:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
                self.transform = .identity
                
                self.miniPlayerView.alpha = 1
            }

        default:
            break
        }
    }
    
    deinit {
        debugPrint("Successfully", #function)
    }
    
    let shrunkenTransform = CGAffineTransform(scaleX: 0.75, y: 0.75)
    
    func animateEpisodeImageView(transform: CGAffineTransform = .identity, damping ratio: CGFloat = 0.5) {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: ratio, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.episodeImageView.transform = transform
        }
    }
    
    fileprivate func playEpisode() {
        guard let url = episode.streamAudioUrl else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    fileprivate func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in
            self?.startTimeLabel.text = time.toDisplayString()
            let duration = self?.player.currentItem?.duration
            self?.endTimeLabel.text = duration?.toDisplayString()
            
            self?.updatePlaybackSlider()
        }
    }
    
    fileprivate func updatePlaybackSlider() {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTime())
        let percentage = currentTimeSeconds / durationSeconds
        playbackSlider.value = Float(percentage)
    }
    
    // MARK:- Set Player UI
    fileprivate func setupPlayerView() {
        dismissButton.constrainHeight(constant: 50)
        episodeImageView.heightAnchor.constraint(equalTo: episodeImageView.widthAnchor, multiplier: 1.0).isActive = true
        titleLabel.constrainHeight(constant: 36)
        titleLabel.adjustsFontSizeToFitWidth = true
        authorLabel.constrainHeight(constant: 20)
        
        endTimeLabel.textAlignment = .right
        titleLabel.textAlignment = .center
        authorLabel.textAlignment = .center
        
        noVolumeImageView.constrainWidth(constant: 26)
        volumeImageView.constrainWidth(constant: 26)
        
        // Play pause stackview
        let controlStackView = HStackView(arrangedSubviews: [
            UIView(), rewindButton,
            UIView(), playPauseButton,
            UIView(), fastForwardButton, UIView()
        ])
        controlStackView.distribution = .equalCentering
        controlStackView.constrainHeight(constant: 140)
        
        // Adjust Volume stackview
        let volumeStackView = HStackView(arrangedSubviews: [
            noVolumeImageView,
            volumeSlider,
            volumeImageView
        ], spacing: 8)
        volumeStackView.constrainHeight(constant: 22)
        
        // Playback time stackview
        let playbackTimeStackView = HStackView(arrangedSubviews: [
            startTimeLabel,
            endTimeLabel
        ])
        playbackTimeStackView.constrainHeight(constant: 20)
        
        // Overall stackview
        maximizedStackView = VStackView(arrangedSubviews: [
            dismissButton,
            episodeImageView,
            playbackSlider,
            playbackTimeStackView,
            titleLabel,
            authorLabel,
            controlStackView,
            volumeStackView
        ], spacing: 6)
        
        addSubview(maximizedStackView)
        maximizedStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 28, left: 24, bottom: 0, right: 24))
//        maximizedStackView.fillSuperview(padding: .init(top: 28, left: 24, bottom: 60, right: 24))
    }
    
    fileprivate func setupMiniPlayerView() {
        addSubview(miniPlayerView)
        miniPlayerView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, size: .init(width: 0, height: 64))
        
        miniEpisodeImageView.constrainWidth(constant: 48)
        miniPlayPauseButton.constrainWidth(constant: 25)
        miniFastForwardButton.constrainWidth(constant: 25)
        
        let stackView = HStackView(arrangedSubviews: [
            miniEpisodeImageView,
            miniTitleLabel,
            UIView(),
            miniPlayPauseButton,
            miniFastForwardButton
        ], spacing: 16)
        
        miniPlayerView.addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 8, left: 16, bottom: 8, right: 16))
        stackView.alignment = .center
        
    }
    
    // Actions
    func setActions() {
        dismissButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        playbackSlider.addTarget(self, action: #selector(handlePlaybackSliderChange(_:)), for: .valueChanged)
        rewindButton.addTarget(self, action: #selector(handleRewind), for: .touchUpInside)
        fastForwardButton.addTarget(self, action: #selector(handleFastForward), for: .touchUpInside)
        volumeSlider.addTarget(self, action: #selector(handleVolumeChange), for: .valueChanged)
    }
    
    @objc func handleDismiss() {
        let mainTabBarController = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController as? MainTabBarController
        mainTabBarController?.minimizePlayer()
    }
    
    @objc func handlePlayPause() {
        if player.timeControlStatus == .paused {
            playPauseButton.setImage(.systemImage(imageName: "pause.fill", size: 40, weight: .regular, scale: .large), for: .normal)
            animateEpisodeImageView()
            player.play()
        } else {
            playPauseButton.setImage(.systemImage(imageName: "play.fill", size: 40, weight: .regular, scale: .large), for: .normal)
            animateEpisodeImageView(transform: shrunkenTransform, damping: 1.0)
            player.pause()
        }
    }
    
    @objc func handlePlaybackSliderChange(_ sender: Any) {
        let percentage = playbackSlider.value
        guard let duration = player.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
        player.seek(to: seekTime)
    }
    
    @objc func handleRewind() {
        seekToCurrentTime(delta: -15)
    }
    
    @objc func handleFastForward() {
        seekToCurrentTime(delta: 15)
    }
    
    fileprivate func seekToCurrentTime(delta: Int64) {
        let fifteenSeconds = CMTimeMake(value: delta, timescale: 1)
        let seekTime = CMTimeAdd(player.currentTime(), fifteenSeconds)
        player.seek(to: seekTime)
    }
    
    @objc func handleVolumeChange() {
        player.volume = volumeSlider.value
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//let totalTime = String(format: "%02d:%02d", totalSeconds/60, totalSeconds%60)
