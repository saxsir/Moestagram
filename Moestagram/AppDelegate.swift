//
//  AppDelegate.swift
//  Moestagram
//
//  Created by Shohei Sasamoto on 2015/02/21.
//  Copyright (c) 2015年 saxsir. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let predefinedMessages = [
        "空を背景に写真を撮ってみよう！",
        "海を背景に写真を撮ってみよう！",
        "山を背景に写真を撮ってみよう！",
        "川を背景に写真を撮ってみよう！",
        "建物を背景に写真を撮ってみよう！"
    ]

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // 初回起動判定
        if NSUserDefaults.standardUserDefaults().boolForKey("hasLaunchedOnce") == false {
            
            // push通知（ローカル）の許可をもらう
            //TODO: これだと初回起動した瞬間にダイアログが出るので、タイミングを変えたい
            requestUserNotificationPermission(application)
            println("requestUserNotificationPermission")
            
            let messages = shuffle(predefinedMessages)

            for i in 0..<messages.count {
                //TODO: リリース時はこっち
                //let fireDate = generateRandomTimeInXDays(i)

                //DEBUG: i*5秒後に通知をセット
                let fireDate = NSDate(timeIntervalSinceNow: NSTimeInterval(5 * (i+1)))

                let alertTitle = "研究協力( ｀・∀・´)ﾉﾖﾛｼｸ"
                let alertBody = messages[i]
                addLocalNotification(fireDate, alertTitle: alertTitle, alertBody: alertBody)
            }
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "me.saxsir.Moestagram" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Moestagram", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Moestagram.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }

    /**
     * 通知周りの処理
     *
     */
    // アプリ起動中に通知がきたらアプリ上に表示する
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        var alert = UIAlertView()
        alert.title = notification.alertTitle
        alert.message = notification.alertBody
        alert.addButtonWithTitle(notification.alertAction!)
        alert.show()
        
        println("show alert when notification fired while app using")
    }

    /**
     * プライベートメソッド
     */

    // x日後のランダムな時刻の日付オブジェクトを返す関数
    func generateRandomTimeInXDays(x: Int) -> NSDate {
        let hours = [8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23] //日本時間
        let rand = Int(arc4random_uniform(UInt32(hours.count)))

        // 24 * x時間後の時刻を取得
        let tomorrow = NSDate(timeIntervalSinceNow: NSTimeInterval(3600 * 24 * x))

        // 時刻だけ更新
        let calendar = NSCalendar(identifier: NSGregorianCalendar)!
        let date = calendar.dateBySettingHour(hours[rand], minute: 00, second: 0, ofDate: tomorrow, options: nil)!

        //XXX: 日本時間とGMT時間考慮してないけどなぜかよしなに設定されている...？
        return date //GMT標準時間
    }

    // ローカル通知を登録する関数
    func addLocalNotification(fireDate: NSDate, alertTitle: String, alertBody: String) {
        var notification = UILocalNotification()
        notification.fireDate = fireDate
        notification.alertTitle = alertTitle
        notification.alertBody = alertBody
        notification.alertAction = "OK"
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func requestUserNotificationPermission(application: UIApplication) {
        //TODO: 許可がもらえなかった場合の処理を追加する
        let settings = UIUserNotificationSettings( forTypes: UIUserNotificationType.Badge | UIUserNotificationType.Sound | UIUserNotificationType.Alert, categories: nil)
        application.registerUserNotificationSettings(settings)
    }
    
    // cf. http://stackoverflow.com/questions/24026510/how-do-i-shuffle-an-array-in-swift
    //TODO: swiftの文法を調べる
    func shuffle<C: MutableCollectionType where C.Index == Int>(var list: C) -> C {
        let count = count(list)
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            swap(&list[i], &list[j])
        }
        return list
    }
}