//
//  misc.swift
//  DinnerSystem
//
//  Created by Sean on 2018/9/13.
//  Copyright © 2018年 Sean.Inc. All rights reserved.
//

import Foundation
import Alamofire

let decoder = JSONDecoder()
let versionNumber = 2019131313
func dsURL(_ cmd: String) -> String{
    return "https://\(dsIP)/dinnersys_beta/backend/backend.php?cmd=\(cmd)"
}
let itmsURL = URL(string: "itms-apps://itunes.apple.com/app/id1352943874")!
let dinnersysURL = "https://\(dsIP)/dinnersys_beta/"
var dsIP = "dinnersystem.com"
struct SelectedFood {
    static var name: String = ""
    static var id: String = ""
    static var cost: String = ""
}

struct SelectedFoodArray {
    var name: String = ""
    var qty: String = ""
    var cost: String = ""
    init (name: String, qty: String, cost: String){
        self.cost = cost
        self.qty = qty
        self.name = name
    }
}
var foodArr: [SelectedFoodArray] = []

extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}

/*
struct loginInfo{
    static var usr = ""
    static var pwd = ""
}
*/

func logout(){
    Alamofire.request("https://\(dsIP)/dinnersys_beta/backend/backend.php?cmd=logout").responseData{_ in}
}

struct Ord{
    static var url = ""
    static var name = ""
}
var usr = ""
var pwd = ""
var fcmToken = ""
var balance = 0
let seatNumArr = Array(1...50)

public func createAlert(_ title: String,_ message: String) -> UIAlertController{
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    return alert
}

extension UIImage {
    
    /// Returns a image that fills in newSize
    func resizedImage(newSize: CGSize) -> UIImage {
        // Guard newSize is different
        guard self.size != newSize else { return self }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
}
