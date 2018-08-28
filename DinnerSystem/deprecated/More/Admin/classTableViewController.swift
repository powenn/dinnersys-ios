//
//  classTableViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2018/3/1.
//  Copyright © 2018年 Sean.Inc. All rights reserved.
//

import UIKit
import Alamofire

class classTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Alamofire.request("http://dinnersys.ddns.net/dinnersys_beta/backend/backend.php?cmd=show_order&payment_filter=nothing&date_filter=week&person_filter=class&type=junk&plugin=yes").responseData{response in
            let decoder = JSONDecoder()
            allArr = []
            monArr = []
            tueArr = []
            wedArr = []
            thuArr = []
            friArr = []
            allArr = try! decoder.decode([classOrder].self, from: response.data!)
            for arr in allArr{
                if arr.recvDate == dInfo[0].monday!{
                    monArr.append(arr)
                }
                if arr.recvDate == dInfo[1].tuesday!{
                    tueArr.append(arr)
                }
                if arr.recvDate == dInfo[2].wednesday!{
                    wedArr.append(arr)
                }
                if arr.recvDate == dInfo[3].thursday!{
                    thuArr.append(arr)
                }
                if arr.recvDate == dInfo[4].friday!{
                    friArr.append(arr)
                }
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

}