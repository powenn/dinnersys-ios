//
//	adminHistoryOrderMaker.swift
//
//	Create by Sean Pai on 1/11/2018
//	Copyright © 2018 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct adminHistoryOrderMaker : Codable {

	let classField : adminHistoryClas?
	let id : String?
	let name : String?
	let prevSum : String?
	let seatNo : String?
	let vege : adminHistoryVege?


	enum CodingKeys: String, CodingKey {
		case classField
		case id = "id"
		case name = "name"
		case prevSum = "prev_sum"
		case seatNo = "seat_no"
		case vege
	}
    init(classField : adminHistoryClas? = nil,
         id : String? = nil,
         name : String? = nil,
         prevSum : String? = nil,
         seatNo : String? = nil,
         vege : adminHistoryVege? = nil
        ){
        self.classField = classField
        self.id = id
        self.name = name
        self.prevSum = prevSum
        self.seatNo = seatNo
        self.vege = vege
    }


}