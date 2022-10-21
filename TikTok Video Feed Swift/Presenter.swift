//
//  Presenter.swift
//  TikTok Video Feed Swift
//
//  Created by Cedan Misquith on 19/10/22.
//

import Foundation

protocol PresenterProtocol: AnyObject {
    func refresh()
}

struct VideoObject {
    var videoURL: String
    var thumbnailURL: String
    var title: String
    var videoDescription: String
    init(videoURL: String, thumbnailURL: String, title: String, videoDescription: String) {
        self.videoURL = videoURL
        self.thumbnailURL = thumbnailURL
        self.title = title
        self.videoDescription = videoDescription
    }
}

class Presenter: NSObject {
    var videos: [VideoObject] = [
        VideoObject.init(
            videoURL: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
            thumbnailURL: "https://picsum.photos/id/0/5616/3744",
            title: "Video 01",
            videoDescription: "This is a description for video 01"),
        VideoObject.init(
            videoURL: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
            thumbnailURL: "https://picsum.photos/id/1/5616/3744",
            title: "Video 02",
            videoDescription: "This is a description for video 02"),
        VideoObject.init(
            videoURL: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
            thumbnailURL: "https://picsum.photos/id/10/2500/1667",
            title: "Video 03",
            videoDescription: "This is a description for video 03"),
        VideoObject.init(
            videoURL: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
            thumbnailURL: "https://picsum.photos/id/100/2500/1656",
            title: "Video 04",
            videoDescription: "This is a description for video 04"),
        VideoObject.init(
            videoURL: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
            thumbnailURL: "https://picsum.photos/id/1000/5626/3635",
            title: "Video 05",
            videoDescription: "This is a description for video 05"),
        VideoObject.init(
            videoURL: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4",
            thumbnailURL: "https://picsum.photos/id/1001/5616/3744",
            title: "Video 06",
            videoDescription: "This is a description for video 06"),
        VideoObject.init(
            videoURL: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4",
            thumbnailURL: "https://picsum.photos/id/1002/4312/2868",
            title: "Video 07",
            videoDescription: "This is a description for video 07")
    ]
    weak var delegate: PresenterProtocol?
    init(delegate: PresenterProtocol) {
        self.delegate = delegate
    }
}
