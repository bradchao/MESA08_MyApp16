//
//  ViewController.swift
//  MyApp16
//
//  Created by user22 on 2017/9/26.
//  Copyright © 2017年 Brad Big Company. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDownloadDelegate, URLSessionDataDelegate {
    
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var imgView: UIImageView!
    private var q1 = DispatchQueue(label: "q1", qos: DispatchQoS.background, attributes: DispatchQueue.Attributes.concurrent)
    
    @IBAction func doTest2(_ sender: Any) {
        let url = URL(string: "http://www.planwallpaper.com/static/images/abstract-background-design.jpg")
        q1.async {
            if let data = try? Data(contentsOf: url!) {
                let img = UIImage(data: data)
                DispatchQueue.main.async {
                    self.imgView.image = img
                }
            }
        }
    }
    
    @IBAction func doTest1(_ sender: Any) {
        progress.progress = 0
        let url = URL(string: "http://www.planwallpaper.com/static/images/abstract-background-design.jpg")
        
        let config = URLSessionConfiguration.background(withIdentifier: "myid")
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        
        let task = session.downloadTask(with: url!)
        task.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("finish download")
        
        if let data = try? Data(contentsOf: location) {
            let img = UIImage(data: data)
            DispatchQueue.main.async {
                self.imgView.image = img
            }
        }
    }
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64){
        print("\(bytesWritten):\(totalBytesWritten):\(totalBytesExpectedToWrite)")
        DispatchQueue.main.async {
            self.progress.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        progress.progress = 0
    }
}

