//
//  Cart.swift
//  RoadToBurger
//
//  Created by Ingenieria on 13/06/22.
//

import Foundation

struct CartProduct: Decodable {
    var _id: String = ""
    var nombre: String = ""
    var cantidad: Int = 0
    var imagen: String = ""
    var productID: String = ""
    var userID: String = ""
    var precio: Int = 0
}
