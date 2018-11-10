//
//	OrderMoney.swift
//
//	Create by Sean Pai on 1/11/2018
//	Copyright © 2018 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct OrderMoney : Codable {

	let charge : String?
	let id : String?
	let payment : [OrderPayment]?


	enum CodingKeys: String, CodingKey {
		case charge = "charge"
		case id = "id"
		case payment = "payment"
	}
    init(charge : String? = nil,
         id : String? = nil,
         payment : [OrderPayment]? = nil
        ){
        self.charge = charge
        self.id = id
        self.payment = payment
    }


}