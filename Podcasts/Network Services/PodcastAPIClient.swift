//
//  PodcastAPIClient.swift
//  Podcasts
//
//  Created by Alex Paul on 12/17/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation

struct PodcastAPIClient {
  
    static func getPodcasts(for searchQuery: String ,completion: @escaping (Result<[Podcast],AppError>)->()) {
            
            let searchQuery = searchQuery
            let podcastEndpointURL = "https://itunes.apple.com/search?media=podcast&limit=200&term=\(searchQuery)"
            
            guard let url = URL(string: podcastEndpointURL) else {
                completion(.failure(.badURL(podcastEndpointURL)))
                return
            }
            
            let request = URLRequest(url: url)
            
            NetworkHelper.shared.performDataTask(with: request) { (result) in
                switch result {
                case .failure(let appError):
                    completion(.failure(.networkClientError(appError)))
                    
                case .success(let data):
                    do {
                        let podcasts = try JSONDecoder().decode(PodcastSearch.self, from: data)
                        completion(.success(podcasts.results))
                    } catch {
                        completion(.failure(.decodingError(error)))
                    }
                }
            }
            
        }
        
        
        static func favoritePodcast(for favorite: Podcast, completion: @escaping (Result<Bool,AppError>)->()) {
            
            let endpointURLString = "https://5c2e2a592fffe80014bd6904.mockapi.io/api/v1/favorites"
                    
                    guard let url = URL(string: endpointURLString) else {
                        completion(.failure(.badURL(endpointURLString)))
                        return
                    }
                    
                    //create data from our Posted Questions.
                    //how? convert PostedQuestions to Data.
                    
                    do {
                        let data = try JSONEncoder().encode(favorite)
                        
                        //configure URL request
                        var request = URLRequest(url: url)
                        
                        //type of httyp method
                        request.httpMethod = "POST"
                        
                        //tpe of data
                        request.addValue("application/json", forHTTPHeaderField: "Content-type")
                        
                        // data being sent to the web api. this is where we created the data.
                        request.httpBody = data
                        
                        //execute post request
                        
                        NetworkHelper.shared.performDataTask(with: request) { (result) in
                            switch result {
                            case .failure(let appError):
                                completion(.failure(.networkClientError(appError)))
                                
                            case .success:
                                completion(.success(true))
                            }
                        }
                        
                    } catch {
                        
                        completion(.failure(.encodingError(error)))
                }
            }
        
        
        
        static func getFavoritesList(completion: @escaping (Result<[Podcast],AppError>)->()) {
            
            let endpointURL = "https://5c2e2a592fffe80014bd6904.mockapi.io/api/v1/favorites"
            
            guard let url = URL(string: endpointURL) else {
                completion(.failure(.badURL(endpointURL)))
                return
            }
            
            let request = URLRequest(url: url)
            
            NetworkHelper.shared.performDataTask(with: request) { (result) in
                switch result {
                case .failure(let appError):
                    completion(.failure(.networkClientError(appError)))
                    
                case .success(let data):
                    do {
                        let favorites = try JSONDecoder().decode([Podcast].self, from: data)
                        completion(.success(favorites))
                    } catch {
                        completion(.failure(.decodingError(error)))
                    }
                }
            }
            
        }
        
    }
        



