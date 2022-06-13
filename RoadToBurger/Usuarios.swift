//
//  Usuarios.swift
//  RoadToBurger
//
//  Created by Ingenieria on 13/06/22.
//

import Foundation

struct Usuario: Decodable {
    var _id: String = ""
    var nombre: String = ""
    var apellido: String = ""
    var password: String = ""
    var username: String = ""
}

struct User: Decodable {
    var _id: String = ""
    var nombre: String = ""
    
}
