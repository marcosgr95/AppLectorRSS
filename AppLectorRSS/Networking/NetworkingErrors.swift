//
//  NetworkingErrors.swift
//  AppLectorRSS
//
//  Created by Marcos García Rouco on 13/3/22.
//

import Foundation

enum NetworkingError: Error {
    case badRequest
    case badURL
    case corruptedData
    case noLink
}
