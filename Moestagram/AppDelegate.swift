//
//  AppDelegate.swift
//  Moestagram
//
//  Created by Shohei Sasamoto on 2015/02/21.
//  Copyright (c) 2015年 saxsir. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // ローカル通知の許可をください
        let settings = UIUserNotificationSettings(
            forTypes: UIUserNotificationType.Badge
                | UIUserNotificationType.Sound
                | UIUserNotificationType.Alert,
            categories: nil)
        application.registerUserNotificationSettings(settings)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

        // 登録されている通知を全てキャンセル
        UIApplication.sharedApplication().cancelAllLocalNotifications()

        // 新しくPush通知（ローカル）を登録する - 1週間分、毎日ランダムな時間に。
        scheduleDailyNotificationForOneWeek()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    /**
     * 通知周りの処理
     *
     */
    // アプリ起動中に通知がきたらアプリ上に表示する
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
        var alert = UIAlertView()
        alert.title = "なんか通知きたよ"
        alert.message = notification.alertBody
        alert.addButtonWithTitle(notification.alertAction!)
        alert.show()
    }

    /**
     * プライベートメソッド
     */
    // 1週間分のデイリー通知を登録する関数
    func scheduleDailyNotificationForOneWeek() {
        for i in 1...7 {
            let fireDate = generateRandomTimeInXDays(i)
            let alertBody = "通知本文"
            addLocalNotification(fireDate, alertBody: alertBody)
        }
    }

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
    func addLocalNotification(fireDate: NSDate, alertBody: String) {
        var notification = UILocalNotification()
        notification.fireDate = fireDate
        notification.alertBody = alertBody
        notification.alertAction = "OK"
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
}