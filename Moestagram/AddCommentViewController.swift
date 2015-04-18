//
//  AddCommentViewController.swift
//  Moestagram
//
//  Created by Shohei Sasamoto on 2015/04/18.
//  Copyright (c) 2015年 saxsir. All rights reserved.
//

import UIKit
import Photos
import CoreData

class AddCommentViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var saveCommentBtn: UIButton!

    var asset = PHAsset()

    override func viewDidLoad() {
        super.viewDidLoad()

        // 最後に撮影した画像を取得
        var options = PHFetchOptions()
        options.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        self.asset = PHAsset.fetchAssetsWithMediaType(.Image, options: options).firstObject as! PHAsset

        let manager: PHImageManager = PHImageManager()
        manager.requestImageForAsset(
            self.asset,
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
        // AppDelegateクラスのインスタンスを取得
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        // AppDelegateクラスからNSManagedObjectContextを取得
        if let managedObjectContext = appDelegate.managedObjectContext {
            // EntityDescriptionのインスタンスを生成
            let entityDiscription = NSEntityDescription.entityForName("PhotoStore", inManagedObjectContext: managedObjectContext);
            // NSFetchRequest SQLのSelect文のようなイメージ
            let fetchRequest = NSFetchRequest();
            fetchRequest.entity = entityDiscription;
            // NSPredicate SQLのWhere句のようなイメージ
            // local_identifierプロパティが最後に撮った写真(asset)のlocalIdentifierのレコードを指定
            let predicate = NSPredicate(format: "%K = %@", "local_identifier", self.asset.localIdentifier)
            fetchRequest.predicate = predicate

            var error: NSError? = nil
            // フェッチリクエストの実行
            if var results:NSArray = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) {
                for managedObject in results {
                    let model = managedObject as! PhotoStore

                    // レコードの更新！
                    model.comment = "hugahuga"
                }
            }

            // AppDelegateクラスに自動生成された saveContext で保存完了
            appDelegate.saveContext()
        }

        // mainViewに戻る
        self.dismissViewControllerAnimated(false, completion: nil)
    }
}