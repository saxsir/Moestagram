//
//  ViewController.swift
//  Moestagram
//
//  Created by Shohei Sasamoto on 2015/02/21.
//  Copyright (c) 2015年 saxsir. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    /*
     * Main.storyboardとの接続周りはこちら
     */
    @IBOutlet weak var launchCameraButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    /*
     * 全体で使う変数はこちら
     */
    var photoAssets = [PHAsset]()

    // カメラボタンが押された時に呼ばれる（ようにMain.storyboardで設定した）
    @IBAction func launchCameraButtonTapped(sender: UIBarButtonItem) {
        let camera = UIImagePickerControllerSourceType.Camera

        if (UIImagePickerController.isSourceTypeAvailable(camera)) {
            var picker = UIImagePickerController()
            picker.sourceType = camera
            // refs http://qiita.com/zucay/items/03080645dde1a62ec570
            picker.delegate = self //pickerさん、何かあったら私（ViewController）を呼んでね
            picker.allowsEditing = false
            self.presentViewController(picker, animated: true, completion: nil)
        } else {
            // refs http://tech.eversense.co.jp/23
            var alert = UIAlertController(title: "Error", message: "There is no camera available", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    // imagePickerControllerさんが写真が撮影されたら呼んでくれる（そういう決まり）
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as UIImage
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoAssets.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as UICollectionViewCell

        let asset = photoAssets[indexPath.row]
        let imageView = cell.viewWithTag(1) as UIImageView

        let manager: PHImageManager = PHImageManager()
        manager.requestImageForAsset(asset,
            targetSize: imageView.frame.size,
            contentMode: .AspectFill,
            options: nil) { (image, info) -> Void in
                imageView.image = image
        }
        return cell
    }

    // アプリが起動して画面がロードされたら呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        var options = PHFetchOptions()
        options.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        var assets: PHFetchResult = PHAsset.fetchAssetsWithMediaType(.Image, options: options)
        assets.enumerateObjectsUsingBlock { (asset, index, stop) -> Void in
            self.photoAssets.append(asset as PHAsset)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

