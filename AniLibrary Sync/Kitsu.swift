//
//  Kitsu.swift
//  AniLibrary Sync
//
//  Created by 桐間紗路 on 2017/06/14.
//  Copyright © 2017 Atelier Shiori. All rights reserved.
//

import Foundation
import Alamofire
import OAuth2

public class Kitsu : NSObject {
    static var oauth2: OAuth2PasswordGrant = OAuth2PasswordGrant(settings:  [
        "client_id":OAuthConstants.KitsuClientKey, "client_secret":OAuthConstants.KitsuSecretKey,"token_uri":"https://kitsu.io/api/oauth/token", "keychain": false] as OAuth2JSON)
    
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
    
    static func login(username: String, password: String, completion: @escaping((success:Bool, error:Error?)) -> Void) {
        oauth2.username = username
        oauth2.password = password
        oauth2.authorize(params: [:], callback: {
            response, error in
            if (error == nil){
                let creddict: Dictionary<String,Any> = ["access_token":oauth2.accessToken!, "expires_in":Utility.jdFromDate(date: oauth2.accessTokenExpiry!), "refresh_token":oauth2.refreshToken!]
                let success: Bool = saveaccount(username: username, oauthcred: creddict)
                completion((success,error))
            }
            else {
                completion((false,error))
            }
        })
        
    }
    
    static func retrieveAccountUsername() -> String {
        let accounts : NSArray? = SSKeychain.accounts(forService: "AniLibrary Sync - Kitsu") as NSArray?
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
    
    static func saveaccount(username: String, oauthcred: Dictionary<String,Any>) -> Bool {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: oauthcred, options: .prettyPrinted)
            return SSKeychain.setPasswordData(jsonData, forService: "AniLibrary Sync - Kitsu", account: username)
        } catch {
            print(error.localizedDescription)
        }
        return false;
    }
    
    static func removeaccount() -> Bool {
        return SSKeychain.deletePassword(forService: "AniLibrary Sync - Kitsu", account: retrieveAccountUsername())
    }
    
    static func retrieveOAuthCred() -> Dictionary<String,Any> {
        let credData: Data = SSKeychain.passwordData(forService: "AniLibrary Sync - Kitsu", account: retrieveAccountUsername())
        do {
            let credJson = try JSONSerialization.jsonObject(with: credData, options: [])
            if let dictFromJSON = credJson as? [String:Any] {
                return dictFromJSON
            }
        }
        catch {
            print(error.localizedDescription)
        }
        return [:]
    }
    
    static func retrieveOAuthToken() -> String {
        let credDic: Dictionary<String,Any> = retrieveOAuthCred()
        let accesstoken: String = credDic["access_token"] as! String
        return accesstoken
    }
    
    static func loadcredentials() {
        oauth2 = OAuth2PasswordGrant.init(settings: [
            "client_id":OAuthConstants.KitsuClientKey, "client_secret":OAuthConstants.KitsuSecretKey,"token_uri":"https://kitsu.io/api/oauth/token", "keychain": false] as OAuth2JSON)
        let cred: Dictionary<String,Any> = retrieveOAuthCred()
        oauth2.accessToken = cred["access_token"] as? String
        oauth2.refreshToken = cred["refresh_token"] as? String
    }
    
    static func checkTokenExpired() -> Bool {
        let credDic: Dictionary<String,Any> = retrieveOAuthCred()
        let expireddatedouble: Double = credDic["expires_in"] as! Double
        let expiredate: Date = Utility.dateFromJd(jd: expireddatedouble)
        if (expiredate > Date()) {
            return true
        }
        return false
    }
    
    static func refreshtoken(completion: @escaping(Bool) -> Void) {
        let username: String = retrieveAccountUsername()
        let cred: Dictionary<String,Any> = retrieveOAuthCred()
        if (checkTokenExpired()) {
            oauth2 = OAuth2PasswordGrant.init(settings: [
                "client_id":OAuthConstants.KitsuClientKey, "client_secret":OAuthConstants.KitsuSecretKey,"token_uri":"https://kitsu.io/api/oauth/token", "keychain": false] as OAuth2JSON)
            oauth2.refreshToken = cred["refresh_token"] as? String
            oauth2.doRefreshToken(callback: {
                response, error in
                if (error == nil){
                    let creddict: Dictionary<String,Any> = ["access_token":oauth2.accessToken!, "expires_in":Utility.jdFromDate(date: oauth2.accessTokenExpiry!), "refresh_token":oauth2.refreshToken!]
                    //Remove Old Account
                    if (removeaccount()) {
                        let success: Bool = saveaccount(username: username, oauthcred: creddict)
                        completion(success)
                    }
                    else {
                        completion(false)
                    }
                }
                else {
                    completion(false)
                }
            })
        }
        completion(true)
    }
}
