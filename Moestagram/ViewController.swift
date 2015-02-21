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
    
    @IBOutlet weak var collectionView: UICollectionView!
    var photoAssets = PHFetchResult()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Moestagramで撮った写真一覧を取得
        self.photoAssets = fetchPhotosTakenWithMoestagram()
        
        // コレクションビューをリロード
        collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
     * カメラ周りの機能
     */
    // カメラボタンが押された時に呼ばれる（ようにMain.storyboardで設定した）
    @IBAction func launchCameraButtonTapped(sender: UIBarButtonItem) {
        if (UIImagePickerController.isSourceTypeAvailable(.Camera)) {
            launchCamera()
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
    
    /**
     * コレクションビュー周りの機能
     */
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoAssets.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as UICollectionViewCell

        let asset = self.photoAssets.objectAtIndex(indexPath.row) as PHAsset
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
    
    /**
     * プライベートメソッド
     */
    private func launchCamera() -> Void {
        var picker = UIImagePickerController()
        picker.sourceType = .Camera
        picker.delegate = self //pickerさん、何かあったら私（ViewController）を呼んでね
        picker.allowsEditing = false
        self.presentViewController(picker, animated: true, completion: nil)
    }

    private func fetchPhotosTakenWithMoestagram() -> PHFetchResult {
        var options = PHFetchOptions()
        // 日付が新しい順にソートして取得する
        options.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]

        return PHAsset.fetchAssetsWithMediaType(.Image, options: options)
    }

}