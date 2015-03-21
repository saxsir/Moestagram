//
//  ViewController.swift
//  Moestagram
//
//  Created by Shohei Sasamoto on 2015/02/21.
//  Copyright (c) 2015年 saxsir. All rights reserved.
//

import UIKit
import Photos

class MainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var photoAssets = PHFetchResult()
    var tappedCellIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if PHPhotoLibrary.authorizationStatus() == .Authorized {
            self.photoAssets = fetchPhotosTakenWithMoestagram()
            println("fetch photos taken with moestagram")
            
            collectionView.reloadData()
            println("reload collection view")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        // 初回起動時のみWelcomeViewControllerに遷移
        if NSUserDefaults.standardUserDefaults().boolForKey("hasLaunchedOnce") == false {
            println("move to Welcome View")
            self.performSegueWithIdentifier("firstLaunchSegue", sender: self)
        }
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
        UIImageWriteToSavedPhotosAlbum(image, self, "didFinishSavingImage:didFinishSavingWithError:contextInfo:", nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // 写真の保存が完了したら呼んでくれる
    func didFinishSavingImage(image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutablePointer<Void>) -> Void {
        self.viewDidLoad()
    }
    
    /**
     * コレクションビュー周りの機能
     */
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if PHPhotoLibrary.authorizationStatus() == .Authorized {
            return self.photoAssets.count
        } else {
            return 0
        }
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
                imageView.contentMode = .ScaleAspectFill
                imageView.image = image
        }

        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "imageTappedSegue") {
            let selectedIndex = self.collectionView.indexPathsForSelectedItems() as [NSIndexPath]
            let imageViewController: ImageViewController = segue.destinationViewController as ImageViewController
            imageViewController.asset = self.photoAssets.objectAtIndex(selectedIndex[0].row) as PHAsset
        } else if (segue.identifier == "firstLaunchSegue") {
            let welcomeViewController: WelcomeViewController = segue.destinationViewController as WelcomeViewController
        }
    }
    
    @IBAction func backFromImageView(segue:UIStoryboardSegue){
        self.viewDidLoad()
    }
    @IBAction func backFromWelcomeView(segue:UIStoryboardSegue){
        self.viewDidLoad()
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