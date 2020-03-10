//
//  CardController.swift
//  DeckOfOneCard
//
//  Created by Jordan Furr on 3/10/20.
//  Copyright © 2020 Warren. All rights reserved.
//

import Foundation
import UIKit

class CardController {
    
    static let baseURL = URL(string: "https://deckofcardsapi.com/api/deck/new/draw/?count=1")
    
    static func fetchCard(completion: @escaping (Result <Card, CardError>) -> Void) {
        
        // 1 - Prepare URL
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL))}
        // 2 - Contact server
        URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            
            // 3) Error Handling
            if let error = error{
                print(error, error.localizedDescription)
                return completion(.failure(.thrown(error)))
            }
            // 4) Check for Data
            guard let data = data else {return completion(.failure(.noData))}
            
            // 5) Decode json into a Card
            do {
                let decoder = JSONDecoder()
                let toplevel = try decoder.decode(TopLevelObject.self, from: data)
                guard let card = toplevel.cards.first else { return completion(.failure(.unableToDecode))}
                return completion(.success(card))
                
            } catch {
                print(error, error.localizedDescription)
                return completion(.failure(.thrown(error)))
            }
        }.resume()
    }
    
    static func fetchImage(for card: Card, completion: @escaping (Result <UIImage, CardError>) -> Void) {
        // 1 - Prepare URL
        let cardURL = card.image
        // 2 - Contact server
        URLSession.shared.dataTask(with: cardURL) { (data, _, error) in
            
            // 3 - Handle errors from the server
            if let error = error {
                print(error, error.localizedDescription)
                return completion(.failure(.thrown(error)))
            }
            // 4 - Check for image data
            guard let data = data else { return completion(.failure(.noData))}
                   
            // 5 - Initialize an image from the data
            guard let cardImage = UIImage(data: data) else {return completion(.failure(.unableToDecode))}
            return completion(.success(cardImage))
        }.resume()
    }
}

