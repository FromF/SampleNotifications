//
//  SecondViewController.swift
//  SampleNotifications
//
//  Created by haruhito on 2017/06/26.
//  Copyright © 2017年 FromF. All rights reserved.
//

import UIKit
import UserNotifications

class SecondViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var setButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    private let settingArray : [Int] = [10,20,30,40,50,60,90]
    
    private let requestIdentifier = "noticationIntervalKey"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Pickerの設定
        picker.delegate = self
        picker.dataSource = self
        
        // Pickerの選択を合わせる
        _ = updateDisplay()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button
    @IBAction func setButtonAction(_ sender: Any) {
        
        let content = UNMutableNotificationContent()
        content.title = "Sample Notifications"
        content.body = "Interval Timer Fire"
        content.sound = UNNotificationSound.default()
        
        let fireTime = updateDisplay()
        var isRepeat = false
        if fireTime >= 60 {
            //60秒以上じゃないと繰り返しできない
            isRepeat = true
        }
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(fireTime), repeats: isRepeat)
        
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
    
    @IBAction func clearButtonAction(_ sender: Any) {
        //未通知の通知設定を削除
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [requestIdentifier])
        //通知済みだが、通知を消していない通知を削除
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [requestIdentifier])
    }
    
    // MARK: - UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return settingArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return String(settingArray[row])
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //表示
        _ = updateDisplay()
    }
    
    // MARK: - 表示
    private func updateDisplay() -> Int{
        let row = picker.selectedRow(inComponent: 0)
        let fireTime = settingArray[row]
        
        timeLabel.text = "通知時間　\(fireTime)秒"
        
        return fireTime
    }
}
