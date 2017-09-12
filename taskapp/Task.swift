//
//  Task.swift
//  taskapp
//
//  Created by 田中優樹 on 2017/09/06.
//  Copyright © 2017年 yuki.tanaka. All rights reserved.
//

import RealmSwift

class Task: Object {
    //管理用ID プライマリキー
    dynamic var id = 0
    
    //タイトル
    dynamic var title = ""
    
    //カテゴリ
    dynamic var category = ""
    
    //内容
    dynamic var contents = ""
    
    //日時
    dynamic var date = NSDate()
    
    //IDをプライマリキーに設定
    override static func primaryKey() -> String? {
        return "id"
    }

}
