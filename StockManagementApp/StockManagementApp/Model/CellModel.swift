//
//  CellModel.swift
//  FM-Task1
//
//  Created by SoiriYuichi on 2022/09/10.
//

import UIKit
import RealmSwift

class CellModel:Object {
    @objc dynamic var time:String = "00:00:00"
    @objc dynamic var stockCount:String = "0"
    @objc dynamic var comment:String = ""
    @objc dynamic var check:Bool = false
    @objc dynamic var image = UIImage(named: "no_image")
}
