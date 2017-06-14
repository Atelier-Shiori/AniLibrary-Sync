//
//  Kitsu.swift
//  AniLibrary Sync
//
//  Created by 桐間紗路 on 2017/06/14.
//  Copyright © 2017 Atelier Shiori. All rights reserved.
//

import Foundation
import Alamofire

public class Kitsu : NSObject {
    static var OAuthClient: OAuth2Swift = OAuth2Swift(consumerKey: OAuthConstants.KitsuClientKey, consumerSecret: OAuthConstants.KitsuSecretKey, authorizeUrl: "https://kitsu.io/api/oauth/token", responseType: "token")
    
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
    
    func listtoListEntryArray(list: Any) -> Array<ListEntry> {
        let listarray: Array<Dictionary<String, Any>> = list as! Array<Dictionary<String, Any>>
        var finalarray: Array<ListEntry> = []
        for entry in listarray {
            var lentry: ListEntry = ListEntry(idnumber: entry["id"] as! Int, showtitle: entry["title"] as! String, wepisodes: entry["watched_episodes"] as! Int, wstatus: entry["watched_status"] as! String, etype: "MyAnimeList")
            lentry.score = entry["score"] as! Float?
            finalarray.append(lentry)
        }
        return finalarray
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
        OAuthClient.authorize(withCallbackURL: "", scope: "password", state: "", parameters: ["grant_type":"password", "username":username, "password":password], headers: [:], success: {
            credential, response, parameters in
            print(credential);
            
        }, failure: {
            error in
            print(error.localizedDescription)
        })
        
    }
    
    static func retrieveAccountUsername() -> String {
        let accounts : NSArray? = SSKeychain.accounts(forService: "AniLibrary Sync") as NSArray?
        if (accounts == nil) {
            return ""
        }
        if (accounts!.count > 0) {
            //retrieve first valid account
            for account in accounts! {
                let a = account as! NSDictionary
                let username : NSString = a.value(forKey: "acct") as! NSString
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
