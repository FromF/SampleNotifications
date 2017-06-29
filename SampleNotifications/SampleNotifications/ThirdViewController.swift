//
//  ThirdViewController.swift
//  SampleNotifications
//
//  Created by haruhito on 2017/06/26.
//  Copyright © 2017年 FromF. All rights reserved.
//

import UIKit
import UserNotifications

class ThirdViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var picker: UIDatePicker!
    @IBOutlet weak var setButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!

    private let requestIdentifier = "noticationDateKey"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Picker設定
        picker.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
        //初回表示更新
        updateDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button
    @IBAction func setButtonAction(_ sender: Any) {
        let calendar = Calendar(identifier: .gregorian)
        let comps = calendar.dateComponents([.month , .day], from: picker.date)
        if let month = comps.month , let day = comps.day {
            
            let content = UNMutableNotificationContent()
            content.title = "Sample Notifications"
            content.subtitle = "誕生日"
            content.body = "おめでとう"
            content.sound = UNNotificationSound.default()
            
            //画像の添付
            //↓のフリー素材を利用
            //http://www.irasutoya.com/2015/05/blog-post_250.html
            if let url = Bundle.main.url(forResource: "wedding_anniversary_cake", withExtension: "png"),
                let attachment = try? UNNotificationAttachment(identifier: requestIdentifier, url: url, options: nil) {
                content.attachments = [attachment]
            }
            
            //誕生日当日の10時に通知する
            var triggerDate = DateComponents()
            triggerDate.month = month
            triggerDate.day = day
            triggerDate.hour = 10
            triggerDate.minute = 0
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
            
            let request = UNNotificationRequest(identifier: requestIdentifier,
                                                content: content,
                                                trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) {
                (error) in
                if let theError = error {
                    // Handle any errors
                    print(theError)
                }
            }
        }
    }
    
    @IBAction func clearButtonAction(_ sender: Any) {
        //未通知の通知設定を削除
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [requestIdentifier])
        //通知済みだが、通知を消していない通知を削除
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [requestIdentifier])
    }

    // MARK: - DatePicker
    func datePickerValueChanged(sender:UIDatePicker) {
        updateDisplay()
    }
    // MARK: - 表示
    private func updateDisplay(){
        let calendar = Calendar(identifier: .gregorian)
        let comps = calendar.dateComponents([.month , .day], from: picker.date)
        if let month = comps.month , let day = comps.day {
            timeLabel.text = "誕生日　\(month)月 \(day)日"
        }
    }
}
