//
//  ImageViewController.swift
//  Moestagram
//
//  Created by Shohei Sasamoto on 2015/02/22.
//  Copyright (c) 2015年 saxsir. All rights reserved.
//

import UIKit
import Photos
import CoreData

class ImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var deleteBtn: UIBarButtonItem!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!

    var asset = PHAsset()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 画像の表示
        let manager: PHImageManager = PHImageManager()
        manager.requestImageForAsset(
            self.asset,
            targetSize: imageView.frame.size,
            contentMode: .AspectFit,
            options: nil) { (image, info) -> Void in
                self.imageView.contentMode = .ScaleAspectFit
                self.imageView.image = image
        }

        // 撮影日時の表示
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        println(dateFormatter.stringFromDate(self.asset.creationDate))
        self.dateLabel.text = dateFormatter.stringFromDate(self.asset.creationDate)

        // コメントの表示
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            let entityDiscription = NSEntityDescription.entityForName("PhotoStore", inManagedObjectContext: managedObjectContext);
            let fetchRequest = NSFetchRequest();
            fetchRequest.entity = entityDiscription;
            let predicate = NSPredicate(format: "%K = %@", "local_identifier", self.asset.localIdentifier)
            fetchRequest.predicate = predicate

            var error: NSError? = nil;
            // フェッチリクエストの実行
            if var results = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) {
                for managedObject in results {
                    let model = managedObject as! PhotoStore;
                    self.commentTextView.text = model.comment
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onDeleteBtnTapped(sender: AnyObject) {
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({ () -> Void in
            PHAssetChangeRequest.deleteAssets([self.asset])
        }, completionHandler: { (success, error) -> Void in
            let mainView: UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("mainView") as! UIViewController
            mainView.hidesBottomBarWhenPushed = false
            self.presentViewController(mainView, animated: true, completion: nil)
        })
    }
    
}
