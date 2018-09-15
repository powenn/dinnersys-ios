//
//  LoginViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2018/4/22.
//  Copyright © 2018年 Sean.Inc. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    //MARK: - Declaration
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var remLogin: UIButton!
    @IBOutlet var remPW: UISwitch!
    var uDefault: UserDefaults!
    
    
    //MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        uDefault = UserDefaults.standard
        if let name = uDefault.string(forKey: "studentName"){
            self.remLogin.isEnabled = true
            self.remLogin.setTitle("以\(name)登入", for: UIControl.State.normal)
        }
    }
    
    // MARK: - quitKeyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        username.resignFirstResponder()
        password.resignFirstResponder()
    }
    
    
    //MARK: - login
    @IBAction func remLogin(_ sender: Any) {
        uDefault = UserDefaults.standard
        let usr = uDefault.string(forKey: "userName")!
        let pwd = uDefault.string(forKey: "passWord")!
        Alamofire.request("\(dsURL("login"))&id=\(usr)&password=\(pwd)").responseData{response in
            if response.error != nil {
                let errorAlert = UIAlertController(title: "Error", message: "不知名的錯誤，請注意網路連線狀態或聯絡管理員。", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
            }
            let string = String(data: response.data!, encoding: .utf8)
            if (string?.contains("無法登入。"))!{
                let alert = UIAlertController(title: "無法登入", message: "請確認帳號密碼是否錯誤，或是否註冊。", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                let decoder = JSONDecoder()
                userInfo = try! decoder.decode(Login.self, from: response.data!)
                userInfo.name = userInfo.name?.trimmingCharacters(in: .whitespaces)
                let alert = UIAlertController(title: "登入成功", message: "歡迎使用點餐系統，\(userInfo.name!)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                    (action: UIAlertAction!) -> () in
                    self.performSegue(withIdentifier: "loginSuccess", sender: nil)
                }))
                self.present(alert, animated: true, completion: nil)
                self.performSegue(withIdentifier: "loginSuccess", sender: nil)
            }
        }
    }
    @IBAction func login(_ sender: Any) {
        var usr = ""
        var pwd = ""
        usr = self.username.text!
        pwd = self.password.text!
        
        Alamofire.request("\(dsURL("login"))&id=\(usr)&password=\(pwd)").responseData{response in
            if response.error != nil {
                let errorAlert = UIAlertController(title: "Error", message: "不知名的錯誤，請注意網路連線狀態或聯絡管理員。", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
            }else{
                let string = String(data: response.data!, encoding: .utf8)
                if (string?.contains("無法登入。"))!{
                    let alert = UIAlertController(title: "無法登入", message: "請確認帳號密碼是否錯誤，或是否註冊。", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else{
                        let decoder = JSONDecoder()
                        userInfo = try! decoder.decode(Login.self, from: response.data!)
                        userInfo.name = userInfo.name?.trimmingCharacters(in: .whitespaces)
                        //remember user
                        if (self.remPW.isOn){
                            self.uDefault.set(usr, forKey: "userName")
                            self.uDefault.set(pwd, forKey: "passWord")
                            self.uDefault.set(userInfo.name!, forKey: "studentName")
                            self.remLogin.isEnabled = true
                            self.remLogin.setTitle("以\(userInfo.name!)登入", for: UIControl.State.normal)
                        }
                        let alert = UIAlertController(title: "登入成功", message: "歡迎使用點餐系統，\(userInfo.name!)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                            (action: UIAlertAction!) -> () in
                            self.performSegue(withIdentifier: "loginSuccess", sender: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    
                    }
                }
            }
        
        
        
        
    }
    
    
    
    
}
