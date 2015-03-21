//
//  WelcomeViewController.swift
//  Moestagram
//
//  Created by Shohei Sasamoto on 2015/03/21.
//  Copyright (c) 2015年 saxsir. All rights reserved.
//

import UIKit
import Foundation
import Photos

// 初回起動時のみしか呼ばれない（はず）
class WelcomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 画像保存用のフォルダを作成
        createPhotoDirectory()
        
        // カメラロールアクセスの許可をもらう
        requestPhotoLibraryAccessPermission()
        
        // 次回起動以降はこの処理を行わないよう設定
        println("set hasLaunchedOnce is true")
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasLaunchedOnce")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func requestPhotoLibraryAccessPermission() {
        //TODO: 許可がもらえなかった場合の処理を追加する
        PHPhotoLibrary.requestAuthorization({(status) -> Void in
            switch status {
            case .Authorized:
                println("authorized")
            case .Denied:
                println("denied")
            case .Restricted:
                println("restricted")
            case .NotDetermined:
                println("not determined")
            }
        })
        
        println("request photo library access permission")
    }
    
    func createPhotoDirectory() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let directoryName = "MoestagramPhotos"
        
        let createPath = documentsPath + "/" + directoryName
        NSFileManager.defaultManager().createDirectoryAtPath(createPath, withIntermediateDirectories: true, attributes: nil, error: nil)
        
        println("create photo directory")
    }
}