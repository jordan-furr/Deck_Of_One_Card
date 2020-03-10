//
//  CardError.swift
//  DeckOfOneCard
//
//  Created by Jordan Furr on 3/10/20.
//  Copyright © 2020 Warren. All rights reserved.
//

import Foundation


enum CardError: LocalizedError {
    
    //what we see
    case invalidURL
    case thrown(Error)
    case noData
    case unableToDecode
    
    //what the user sees
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Internal error. Please update Deck of One Card or contact support."
        case .thrown(let error):
            return error.localizedDescription
        case .noData:
            return "The server responded with no data."
        case .unableToDecode:
            return "The server responded with bad data."
        }
    }
}
