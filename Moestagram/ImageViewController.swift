//
//  ImageViewController.swift
//  Moestagram
//
//  Created by Shohei Sasamoto on 2015/02/22.
//  Copyright (c) 2015年 saxsir. All rights reserved.
//

import UIKit
import Photos

class ImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    var asset = PHAsset()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let manager: PHImageManager = PHImageManager()
        manager.requestImageForAsset(
            asset,
            targetSize: imageView.frame.size,
            contentMode: .AspectFit,
            options: nil) { (image, info) -> Void in
                self.imageView.contentMode = .ScaleAspectFit
                self.imageView.image = image
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
