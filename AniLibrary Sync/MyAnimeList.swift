//
//  MyAnimeList.swift
//  AniLibrary Sync
//
//  Created by 桐間紗路 on 2017/06/02.
//  Copyright © 2017 Atelier Shiori. All rights reserved.
//

import Foundation
import Alamofire

public class MyAnimeList : NSObject {
    func retrieveList(username: String, success: @escaping (Any) -> Void, error: @escaping (Error) -> Void)  {
        let URLStr : String = UserDefaults.standard.string(forKey: "MALAPIURL")!+"/2.1/animelist" + UserDefaults.standard.string(forKey: "MALUsername")!
        Alamofire.request(URLStr).responseJSON { response in
            switch response.result {
            case .success:
                success(response.result);
            case .failure:
                error(response.error!);
            }
        }
    }
    
    func search(term: String, success: @escaping (Any) -> Void, error: @escaping (Error) -> Void) {
        let URLStr : String = "https://myanimelist.net/api/anime/search.xml?q=" + term.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        Alamofire.request(URLStr).responseString { response in
            switch response.result {
            case .success:
                success(XMLtoAtarashiiFormat.malSearchXML(toAtarashiiDataFormat: response.value!))
            case .failure:
                error(response.error!)
            }
        }
    }
    
    func addtitle(aniid: Int!, episode: Int!, status: String!, score: Int?, success: @escaping(Any) -> Void, error: @escaping(Error) -> Void) {
        let URLStr : String = UserDefaults.standard.string(forKey: "MALAPIURL")!+"/2.1/animelist/anime"
        let parameters : Parameters = [
            "id":aniid,
            "episode":episode,
            "status":status,
            "score":score ?? 0
        ]
        Alamofire.request(URLStr, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: [:])
            .responseJSON { response in
            switch response.result {
            case .success:
                success(response.result.value as Any);
            case .failure:
                error(response.error!);
            }
        }
        
    }
    
    func updatetitle(aniid: Int!, episode: Int!, status: String!, score: Int?, success: @escaping(Any) -> Void, error: @escaping(Error) -> Void) {
        let URLStr : String = UserDefaults.standard.string(forKey: "MALAPIURL")!+"/2.1/animelist/anime/" + String(aniid)
        let parameters : Parameters = [
            "episode":episode,
            "status":status,
            "score":score ?? 0
        ]
        Alamofire.request(URLStr, method: .patch, parameters: parameters, encoding: URLEncoding.default, headers: [:])
            .responseJSON { response in
                switch response.result {
                case .success:
                    success(response.result.value as Any);
                case .failure:
                    error(response.error!);
                }
        }
    }
    
    func deletetitle(aniid: Int!, success: @escaping(Any) -> Void, error: @escaping(Error) -> Void) {
        let URLStr : String = UserDefaults.standard.string(forKey: "MALAPIURL")!+"/2.1/animelist/anime/" + String(aniid)
        Alamofire.request(URLStr, method: .delete, parameters: [:], encoding: URLEncoding.default, headers: [:])
            .responseJSON { response in
                switch response.result {
                case .success:
                    success(response.result.value as Any);
                case .failure:
                    error(response.error!);
                }
        }
    }
    
    static func login(username: String, password: String, success: @escaping(Any) -> Void, error: @escaping(Error) -> Void) {
        let URLStr : String = UserDefaults.standard.string(forKey: "MALAPIURL")!+"/1/account/verify_credentials"
        Alamofire.request(URLStr, method: .delete, parameters: [:], encoding: URLEncoding.default, headers: ["Authorization":"Basic " + Utility.base64Encoding(string: username + ":" + password)])
            .responseJSON { response in
                switch response.result {
                case .success:
                    success(response.result.value as Any);
                case .failure:
                    error(response.error!);
                }
        }
        
    }
    
    static func retrieveAccountUsername() -> String {
        let accounts : NSArray = SSKeychain.accounts(forService: "AniLibrary Sync") as NSArray
        if (accounts.count > 0) {
            //retrieve first valid account
            for account in accounts {
                let a = account as! NSDictionary
                let username : NSString = a.value(forKey: "username") as! NSString
                return username as String
            }
        }
        return ""
    }
    
    static func saveaccount(username: String, password: String) -> Bool {
        return SSKeychain.setPassword(password, forService: "AniLibrary Sync", account: username)
    }
    
    static func removeaccount() -> Bool {
        return SSKeychain.deletePassword(forService: "AniLibrary Sync", account: retrieveAccountUsername())
    }
    
    static func retrieveBase64() -> String {
        let username : String = retrieveAccountUsername()
        let password : String = SSKeychain.password(forService: "AniLibrary Sync", account: username)
        return Utility.base64Encoding(string: username + ":" + password)
    }
}
