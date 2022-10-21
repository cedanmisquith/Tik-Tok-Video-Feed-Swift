//
//  VideoCustomCell.swift
//  TikTok Video Feed Swift
//
//  Created by Cedan Misquith on 19/10/22.
//

import UIKit
import AVFoundation

class VideoCustomCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var bottomGradientImageView: UIImageView!
    var playerController: VideoPlayerController?
    var videoLayer: AVPlayerLayer = AVPlayerLayer()
    var videoURL: String? {
        didSet {
            if let videoURL = videoURL {
                VideoPlayerController.sharedVideoPlayer.setupVideoFor(url: videoURL)
            }
            videoLayer.isHidden = videoURL == nil
        }
    }
    override func awakeFromNib() {
        let bottomGradient = Utilities.shared.createGradient(color1: UIColor.black.withAlphaComponent(0.0),
                                            color2: UIColor.black.withAlphaComponent(0.7),
                                            frame: bottomGradientImageView.bounds)
        bottomGradientImageView.contentMode = .scaleAspectFill
        bottomGradientImageView.image = bottomGradient
        self.contentView.backgroundColor = .random
        videoLayer.backgroundColor = UIColor.clear.cgColor
        videoLayer.videoGravity = AVLayerVideoGravity.resize
        thumbnailImageView.layer.addSublayer(videoLayer)
        selectionStyle = .none
    }
    override func prepareForReuse() {
        thumbnailImageView.imageURL = nil
        super.prepareForReuse()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        videoLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
    }
    func configureCell(data: VideoObject) {
        self.thumbnailImageView.imageURL = data.thumbnailURL
        self.videoURL = data.videoURL
        self.titleLabel.text = data.title
        self.descriptionLabel.text = data.videoDescription
    }
}
extension VideoCustomCell: PlayVideoLayerContainer {
    func visibleVideoHeight() -> CGFloat {
        let videoFrameInParentSuperView: CGRect? = self.superview?.superview?.convert(
            thumbnailImageView.frame,
            from: thumbnailImageView)
        guard let videoFrame = videoFrameInParentSuperView,
              let superViewFrame = superview?.frame else {
                  return 0
              }
        let visibleVideoFrame = videoFrame.intersection(superViewFrame)
        return visibleVideoFrame.size.height
    }
}
