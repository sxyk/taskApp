//
//  inputViewController.swift
//  taskapp
//
//  Created by 田中優樹 on 2017/08/30.
//  Copyright © 2017年 yuki.tanaka. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class inputViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var categoryPicker: UIPickerView!
    @IBOutlet var contentsTextView: UITextView!
    @IBOutlet var datePicker: UIDatePicker!
    
    let categoryList = ["優先度高","優先度中","優先度低"]
    
    let realm = try! Realm()
    var task: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        categoryPicker.selectRow(1, inComponent: 0, animated: true)
        
        
        //背景をタップしたらdismissKeyBoardメソッドを呼ぶように設定する
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector (dismissKeyBoard))
        self.view.addGestureRecognizer(tapGesture)
        
        titleTextField.text = task.title
        contentsTextView.text = task.contents
        let categoryLow = categoryList.index(of: task.category)
        if categoryLow != nil {
            categoryPicker.selectRow(categoryLow!, inComponent: 0, animated: true)
        }
        datePicker.date = task.date as Date
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let categoryLow = categoryPicker.selectedRow(inComponent: 0)
        try! realm.write {
            self.task.title = self.titleTextField.text!
            self.task.category = self.categoryList[categoryLow]
            self.task.contents = self.contentsTextView.text
            self.task.date = self.datePicker.date as NSDate
            self.realm.add(self.task, update: true)
        }
        
        setNotification(task: task)
        
        super.viewWillDisappear(animated)
    }
    
    //タスクのローカル通知を登録する
    func setNotification(task: Task) {
        let content = UNMutableNotificationContent()
        content.title = task.title
        content.body = task.contents //コンテンツが空だと音しか出ない
        content.sound = UNNotificationSound.default()
        
        //ローカル通知が発動するtrigger(日付マッチ)を作成
        let calendar = NSCalendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: task.date as Date)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponents, repeats: false)
        
        //identifier,content,triggerからローカル通知を作成（identifierが同じだとローカル通知を上書き保存）
        let request = UNNotificationRequest.init(identifier: String(task.id), content:content, trigger:trigger)
        
        //ローカル通知を登録
        let center = UNUserNotificationCenter.current()
        center.add(request) {(error) in
            print(error ?? "ローカル通知登録　OK") //errorがnilならローカル通知の登録に成功したと表示。errorがあればerrorを表示
        }
        
        //未通知のローカル通知一覧をログ出力
        center.getPendingNotificationRequests { (requests: [UNNotificationRequest] ) in
            for request in requests {
                print("---------")
                print("Request")
                print("---------")
                
            }
        }
    }
    
    //UIPickerViewDataSourceのプロトコル
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryList.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //UIPickerViewDelegateのプロトコル
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(categoryList[row])
        //Realmに書きに行く
    }
    
    
    
    
    func dismissKeyBoard() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
