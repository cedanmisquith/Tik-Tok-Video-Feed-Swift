//
//  ViewController.swift
//  TikTok Video Feed Swift
//
//  Created by Cedan Misquith on 19/10/22.
//

import UIKit
class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topGradientImageView: UIImageView!
    var presenter: Presenter!
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = Presenter(delegate: self)
        configureGradients()
        configureTableView()
        DispatchQueue.main.async {
            VideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: self.tableView)
        }
    }
    fileprivate func configureGradients() {
        let topGradient = Utilities.shared.createGradient(color1: UIColor.black.withAlphaComponent(0.7),
                                         color2: UIColor.black.withAlphaComponent(0.0),
                                         frame: topGradientImageView.bounds)
        
        topGradientImageView.contentMode = .scaleAspectFill
        topGradientImageView.image = topGradient
    }
    fileprivate func configureTableView() {
        tableView.isPagingEnabled = true
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(UINib(nibName: "VideoCustomCell", bundle: nil),
                           forCellReuseIdentifier: "VideoCustomCell")
    }
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.videos.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCustomCell") as? VideoCustomCell else {
            return UITableViewCell()
        }
        cell.configureCell(data: presenter.videos[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let videoCell = cell as? PlayVideoLayerContainer {
            if videoCell.videoURL != nil {
                VideoPlayerController.sharedVideoPlayer.removeLayerFor(cell: videoCell)
            }
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        VideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: tableView)
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            VideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: tableView)
        }
    }
}
extension ViewController: PresenterProtocol {
    func refresh() {
    }
}
