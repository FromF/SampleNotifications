//
//  FirstViewController.swift
//  SampleNotifications
//
//  Created by haruhito on 2017/06/26.
//  Copyright © 2017年 FromF. All rights reserved.
//

import UIKit
import UserNotifications

class FirstViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //通知の許可を要求
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert , .sound , .badge]) { (granted, error) in
            if !granted {
                //許可が得られなかったので確認表示を行う
                let controller = UIAlertController(title: "確認", message: "通知を許可する場合には「設定＞通知」にてオンにする設定をしてください", preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

