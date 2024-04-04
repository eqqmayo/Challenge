//
//  DataManager.swift
//  MyGithub
//
//  Created by CaliaPark on 4/3/24.
//

import Foundation
import Alamofire

class DataManager {
    
    var profile: Profile = Profile(name: "길동이", avatarURL: "https://avatars.githubusercontent.com/u/144116848?v=4", location: "한양", followers: 123, following: 456)
    var repositoryArr: [Repository] = []

    func callAPI() async {
        let urlProfile = API.baseURL + "users/eqqmayo"
        let urlRepo = API.baseURL + "users/eqqmayo/repos"
        let urlAppleRepo = API.baseURL + "users/apple/repos"
        let parameter = ["sort": "pushed", "page": "1"]
        
        do {
            self.profile = try await fetchProfile(url: urlProfile)
            self.repositoryArr = try await fetchRepositories(url: urlRepo, parameters: parameter)
            self.repositoryArr = try await fetchRepositories(url: urlAppleRepo, parameters: parameter)
        } catch {
            print("Error: \(error)")
        }
    }
    
    func fetchProfile(url: String) async throws -> Profile {
        try await withCheckedThrowingContinuation { continuation in
            AF.request(url,
                       method: .get,
                       encoding: URLEncoding.default,
                       headers: ["Content-Type": "application/json", "Accept": "application/json"])
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Profile.self) { response in
                switch response.result {
                case .success(let profile):
                    continuation.resume(returning: profile)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func fetchRepositories(url: String, parameters: Parameters) async throws -> [Repository] {
        try await withCheckedThrowingContinuation { continuation in
            AF.request(url,
                       method: .get,
                       parameters: parameters,
                       encoding: URLEncoding.default,
                       headers: ["Content-Type": "application/json", "Accept": "application/json"])
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [Repository].self) { response in
                switch response.result {
                case .success(let repositories):
                    continuation.resume(returning: repositories)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func getProfile() -> Profile {
        return profile
    }
    
    func getRepository() -> [Repository] {
        return repositoryArr
    }
}

struct Profile: Codable {
    let name: String
    let avatarURL: String
    let location: String
    let followers, following: Int
    
    enum CodingKeys: String, CodingKey {
            case name, location, followers, following
            case avatarURL = "avatar_url"
        }
}

struct Repository: Codable {
    let name: String
    let description: String?
    let language: String?
}
