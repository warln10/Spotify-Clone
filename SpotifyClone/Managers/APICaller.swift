//
//  APICaller.swift
//  SpotifyClone
//
//  Created by Warln on 27/03/22.
//

import UIKit

final class APICaller {
    static let shared = APICaller()
    
    private init () {}
    
    enum APIError: Error {
        case failedToGetData
    }
    
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    
    func createRequest(
        with url: URL?,
        type: HTTPMethod,
        completion: @escaping (URLRequest) -> Void
    ) {
        
        AuthManager.shared.withValidToken { token in
            guard let apiURl = url else {return}
            var request = URLRequest(url: apiURl)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
        
    }
    
    //MARK: - User Profile
    
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfileResponse,Error>) -> Void ){
        createRequest(with: URL(string: Constant.BASE_URL2 + Constant.profile), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                do{
                    let result = try JSONDecoder().decode(UserProfileResponse.self, from: data)
                    completion(.success(result))
                }catch{
                    completion(.failure(APIError.failedToGetData))
                }
            }
            task.resume()
        }
    }
    
    //MARK: - Get Started
    
    public func getNewRelease(completion: @escaping (Result<NewReleaseResponse,Error>) -> Void ) {
        createRequest(with: URL(string: Constant.BASE_URL2 + Constant.NewRelease_Api), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _ , error in
                guard let data = data, error == nil else {
                    return
                }
                do{
                    let result = try JSONDecoder().decode(NewReleaseResponse.self, from: data)
                    completion(.success(result))
                }catch{
                    completion(.failure(APIError.failedToGetData))
                }
            }
            task.resume()
        }
    }
    
    public func getFeaturedPlaylist(completion: @escaping (Result<FeaturePlaylistResponse,Error>) -> Void ) {
        createRequest(with: URL(string: Constant.BASE_URL2 + Constant.FeaturePlay_Api), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _ , error in
                guard let data = data, error == nil else {
                    return
                }
                do{
                    let result = try JSONDecoder().decode(FeaturePlaylistResponse.self, from: data)
                    completion(.success(result))
                }catch{
                    completion(.failure(APIError.failedToGetData))
                }
            }
            task.resume()
        }
    }
    
    public func getRecommendationGeners(completion: @escaping (Result<GenereResponse,Error>) -> Void) {
        createRequest(with: URL(string: Constant.BASE_URL2 + Constant.Seed_Api), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _ , error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(GenereResponse.self, from: data)
                    completion(.success(result))
                }catch{
                    completion(.failure(APIError.failedToGetData))
                }
            }
            task.resume()
        }
    }
    
    public func getRecommendation(with seeds: Set<String>, completion: @escaping (Result<RecommendedResponse,Error>) -> Void ) {
        let seed = seeds.joined(separator: ",")
        createRequest(with: URL(string: Constant.BASE_URL2 + "recommendations?limit=40&seed_genres=\(seed)"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _ , error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(RecommendedResponse.self, from: data)
                    completion(.success(result))
                }catch{
                    print(error.localizedDescription)
                    completion(.failure(APIError.failedToGetData))
                }
            }
            task.resume()
        }
    }
    
    //MARK: - Get Albums
    
    public func getAblumDetails(for album: Albums, completion: @escaping (Result<AlbumsDetailResponse,Error>) -> Void ) {
        createRequest(with: URL(string: Constant.BASE_URL2 + "albums/" + album.id), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _ , error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(AlbumsDetailResponse.self, from: data)
                    completion(.success(result))
                }catch{
                    completion(.failure(APIError.failedToGetData))
                }
            }
            task.resume()
        }
    }
    
    //MARK: - Get Play
    
    public func getPlaylistDetail(for playlist: Playlist, completion: @escaping (Result<PlaylistDetailResponse,Error>) -> Void ) {
        createRequest(with: URL(string: Constant.BASE_URL2 + "playlists/" + playlist.id), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _ , error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(PlaylistDetailResponse.self, from: data)
                    completion(.success(result))
                }catch{
                    completion(.failure(APIError.failedToGetData))
                }
            }
            task.resume()
        }
    }
    
    //MARK: - Get Cetogary
    public func getCategories(completion: @escaping (Result<Categories,Error>) -> Void ) {
        createRequest(with: URL(string: Constant.BASE_URL2 + "browse/categories?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(CategoryResponse.self, from: data)
                    completion(.success(result.categories))
                    
                }catch{
                    completion(.failure(APIError.failedToGetData))
                }
            }
            task.resume()
        }
    }
    
    public func categoryPlaylist(category: Category , completion: @escaping (Result<[Playlist],Error>) -> Void ) {
        createRequest(with: URL(string: Constant.BASE_URL2 + "browse/categories/\(category.id)/playlists?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _ , error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(FeaturePlaylistResponse.self, from: data)
                    completion(.success(result.playlists.items))
                }catch {
                    print(APIError.failedToGetData)
                }
            }
            task.resume()
        }
    }
    
    //MARK: - Search Api
    public func getSearch(with query: String, completion: @escaping (Result<[SearchResult],Error>) -> Void ) {
        createRequest(with: URL(string: Constant.BASE_URL2 + "search?limit=20&type=album,artist,playlist,track&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" ),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _ , error in
                guard let data = data , error == nil  else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(SearchResultResponse.self, from: data)
                    var searchResult: [SearchResult] = []
                    searchResult.append(contentsOf: result.albums.items.compactMap({.Album(model: $0)}))
                    searchResult.append(contentsOf: result.playlists.items.compactMap({.Playlist(model: $0)}))
                    searchResult.append(contentsOf: result.artists.items.compactMap({.artist(model: $0)}))
                    searchResult.append(contentsOf: result.tracks.items.compactMap({.track(model: $0)}))
                    completion(.success(searchResult))
                }catch{
                    completion(.failure(APIError.failedToGetData))
                }
            }
            task.resume()
        }
    }
    
}
