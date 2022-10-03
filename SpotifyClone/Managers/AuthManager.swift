//
//  AuthManager.swift
//  SpotifyClone
//
//  Created by Warln on 27/03/22.
//

import UIKit

final class AuthManager {
    static let shared = AuthManager()
    private init () {}
    
    private var refreshingToken = false
    
    public var isSignedIn: Bool {
        return accessToken != ""
    }
    
    private var accessToken: String?{
        return UserDefaults.standard.value(forKey: "access_token") as? String ?? ""
    }
    
    private var experationToken: Date?{
        return UserDefaults.standard.value(forKey: "expires_in") as? Date
    }
    
    private var refreshToken: String?{
        return UserDefaults.standard.value(forKey: "refresh_token") as? String ?? ""
    }
    
    private var shouldRefreshToken: Bool {
        guard let experation = experationToken else {
            return false
        }
        let current = Date()
        let fiveMin: TimeInterval = 300
        return current.addingTimeInterval(fiveMin) >= experation
    }
    
    public var signInURl: URL? {
        let string = "\(Constant.BASE_URl)/authorize?response_type=code&client_id=\(Constant.Client_Id)&scope=\(Constant.scope)&redirect_uri=\(Constant.redirect_uri)&show_dialog=TRUE"
        return URL(string: string)
    }
    
    public func getSpotifyToken(code:String , completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: Constant.BASE_URl+Constant.appToken) else { return }
        var component = URLComponents()
        component.queryItems = [
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constant.redirect_uri),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        let baseString = Constant.Client_Id+":"+Constant.Client_Secret
        guard let base64String = baseString.data(using: .utf8)?.base64EncodedString() else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = component.query?.data(using: .utf8)
        request.allHTTPHeaderFields = ["Authorization":"Basic \(base64String)","Content-Type":"application/x-www-form-urlencoded"]
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            do{
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                completion(true)
                self?.cacheToken(result: result)
            }catch{
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
    
    private var onRefreshBlock = [((String) -> Void)]()
    
    public func withValidToken(completion: @escaping (String) -> Void) {
        guard !refreshingToken else {
            onRefreshBlock.append(completion)
            return
        }
        if shouldRefreshToken {
            refreshIfNeeded { [weak self] success in
                if let token = self?.accessToken, success {
                    completion(token)
                }
            }
        }else if let token = accessToken {
            completion(token)
        }
    }
    
    public func refreshIfNeeded(completion: ((Bool) -> Void)? ) {
        guard !refreshingToken else {
            return
        }
        guard shouldRefreshToken else {
            completion?(true)
            return
        }
        guard let refreshToken = self.refreshToken else { return }
        guard let url = URL(string: Constant.BASE_URl+Constant.appToken) else { return }
        refreshingToken = true
        var component = URLComponents()
        component.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        let baseString = Constant.Client_Id+":"+Constant.Client_Secret
        guard let base64String = baseString.data(using: .utf8)?.base64EncodedString() else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = component.query?.data(using: .utf8)
        request.allHTTPHeaderFields = ["Authorization":"Basic \(base64String)","Content-Type":"application/x-www-form-urlencoded"]
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            self?.refreshingToken = false
            guard let data = data, error == nil else {
                completion?(false)
                return
            }
            do{
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.onRefreshBlock.forEach({$0(result.access_token)})
                self?.onRefreshBlock.removeAll()
                self?.cacheToken(result: result)
                completion?(true)
            }catch{
                print(error.localizedDescription)
                completion?(false)
            }
        }
        task.resume()
        
    }
    
    private func cacheToken(result: AuthResponse) {
        UserDefaults.standard.set(result.access_token, forKey: "access_token")
        UserDefaults.standard.set(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expires_in")
        if let refresh = result.refresh_token {
            UserDefaults.standard.set(refresh, forKey: "refresh_token")
        }
        
    }
}
