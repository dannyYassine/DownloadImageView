//
//  DownloadImageView.swift
//
//  Created by Danny Yassine on 2016-06-18.
//  Copyright © 2016 Danny Yassine. All rights reserved.
//

import UIKit

class DownloadImageView: UIImageView {

    var progressLayer: CAShapeLayer! {
        didSet {
            self.progressLayer.lineWidth = 2.0
            self.progressLayer.fillColor = UIColor.clearColor().CGColor
            self.progressLayer.strokeColor = UIColor.redColor().CGColor
            self.progressLayer.lineCap = kCALineCapRound
        }
    }
    var progress: CGFloat {
        set {
            if newValue > 1 {
                self.progressLayer.strokeEnd = 1.0
            } else if newValue < 0.0 {
                self.progressLayer.strokeEnd = 0.0
            } else {
                self.progressLayer.strokeEnd = newValue
            }
        }
        get {
            return self.progressLayer.strokeEnd
        }
    }
    
    // Download properties
    var imageData: NSData!
    var totalBytes: UInt!
    var receivedBytes: UInt!
    
    // Progress and completion handlers
    var progressHandler: ((progress: CGFloat) -> Void)?
    var completionHandler: ((image: UIImage?) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func initProperties() {
        self.progress = 1.0
    }
    
    private func commonInit() {
        
        self.progressLayer = CAShapeLayer()
        self.progressLayer.frame = self.bounds
        self.layer.addSublayer(self.progressLayer)
        
        self.progress = 0.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.progressLayer.frame = self.bounds
        self.progressLayer.path = UIBezierPath(ovalInRect: self.middleCircleFrame()).CGPath
        
    }
    
    private func middleCircleFrame() -> CGRect {
        var circleFrame = CGRect(x: 0, y: 0, width: self.bounds.width / 4, height: self.bounds.height / 4)
        circleFrame.origin.x = (self.bounds.width - circleFrame.width) / 2
        circleFrame.origin.y = (self.bounds.height - circleFrame.height) / 2
        return circleFrame
    }
    
    func setDownloadTask(url: String, progress: ((progress: CGFloat) -> Void)?, completion: ((image: UIImage?) -> Void)?) {
        
        self.progressHandler = progress
        self.completionHandler = completion
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        let request = NSURLRequest(URL: NSURL(string: url)!)
        let downloadTask = session.downloadTaskWithRequest(request)
        downloadTask.resume()
        
    }
    
    func resetProgress() {
        self.progress = 0.0
    }

}

extension DownloadImageView: NSURLSessionDownloadDelegate {
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        let image = UIImage(data: NSData(contentsOfURL: location)!)
        self.progress = 0.0
        self.completionHandler?(image: image)
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        self.progress = progress
        self.progressHandler?(progress: progress)
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        
    }
    
}
