//
//  AddCommentViewController.swift
//  Moestagram
//
//  Created by Shohei Sasamoto on 2015/04/18.
//  Copyright (c) 2015年 saxsir. All rights reserved.
//

import UIKit
import Photos

class AddCommentViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var saveCommentBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // 最後に撮影した画像を取得
        var options = PHFetchOptions()
        options.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        let asset = PHAsset.fetchAssetsWithMediaType(.Image, options: options).firstObject as! PHAsset

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


    @IBAction func onSaveCommentBtnTapped(sender: AnyObject) {
        // mainViewに戻る
        self.dismissViewControllerAnimated(false, completion: nil)
    }
}