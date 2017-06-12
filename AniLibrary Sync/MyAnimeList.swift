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
        let URLStr : String = UserDefaults.standard.string(forKey: "MALAPIURL")!+"2.1/animelist" + UserDefaults.standard.string(forKey: "MALUsername")!
        Alamofire.request(URLStr).responseJSON { response in
            switch response.result {
            case .success:
                success(response.result);
            case .failure:
                error(response.error!);
            }
        }
    }
    
    func search(term: String, success: @escaping (XMLIndexer) -> Void, error: @escaping (Error) -> Void) {
        let URLStr : String = "https://myanimelist.net/api/anime/search.xml?q=" + term.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        Alamofire.request(URLStr).responseString { response in
            switch response.result {
            case .success:
                success(SWXMLHash.parse(response.value!));
            case .failure:
                error(response.error!);
            }
        }
    }
    
    func addtitle(aniid: Int!, episode: Int!, status: String!, score: Int?, success: @escaping(Any) -> Void, error: @escaping(Error) -> Void) {
        let URLStr : String = UserDefaults.standard.string(forKey: "MALAPIURL")!+"2.1/animelist/anime"
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
        let URLStr : String = UserDefaults.standard.string(forKey: "MALAPIURL")!+"2.1/animelist/anime/" + String(aniid)
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
        let URLStr : String = UserDefaults.standard.string(forKey: "MALAPIURL")!+"2.1/animelist/anime/" + String(aniid)
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
}
