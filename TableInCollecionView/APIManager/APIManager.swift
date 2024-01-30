/*
 Trend TV : https://api.themoviedb.org/3/trending/tv/{time_window}
 
 time_window : string required Default: day
 
 Top TV : https://api.themoviedb.org/3/tv/top_rated
 Popular TV : https://api.themoviedb.org/3/tv/popular
 */
import Foundation
import Alamofire

class TMDBManager {
    static let shard = TMDBManager()
    private init() {}
    
    enum BasicUrl {
        static let trendTV = "https://api.themoviedb.org/3/trending/tv"
        static let topRatedTV = "https://api.themoviedb.org/3/tv/top_rated"
        static let popularTV = "https://api.themoviedb.org/3/tv/popular"
        static let image = "https://image.tmdb.org/t/p/w500/"
    }
    enum Header {
        static let tbdb: HTTPHeaders = [
           "Authorization" : APIKey.tmdb
        ]
    }
    enum TrendType {
        static let day = "/day"
        static let week = "/week"
    }
    
    // MARK: - 테스트를 위해 숫자를 마구잡이로 -> 하게되면 만들어둔 배열이 0 1 2 3 이런식이라 고민 많이 해야함
    enum TMDBTag: Int {
        case trendTV
        case topRatedTV
        case popularTV
        
        func getTMDBTagString() -> String {
            switch self {
            case .trendTV:
                "트렌트"
            case .topRatedTV:
                "TOP RATED"
            case .popularTV:
                "POPULAR"
            }
        }
        
        static func from(tagNum: Int) -> TMDBTag? {
            return TMDBTag(rawValue: tagNum)
        }
    }
    
    
    func petchTrendTV(TrendType: String, compliteHandeler: @escaping ([Results]) -> Void) {
        let url = BasicUrl.trendTV + TrendType
        
        // 모델 만들어 오기 V
        // 성공하는지 테스트 해보기 1차 responseSerializationFailed
        // 2차 성공
        // 이제 성공한 값을 이 메서드를 사용하는 시점으로 던져 주어야 한다. V
        // eascaping 시도 하려하니 잘 받아 가는지 테스트
        AF.request(url,method: .get, headers: Header.tbdb).responseDecodable(of: TMDBTV.self) { response in
            switch response.result {
            case .success(let success):
                // print(success)
                compliteHandeler(success.results)
            case .failure(let failure):
                print(failure)
            }
        }
        
    }
    
    
    func petchTVTopRated( compliteHandler : @escaping ([TopResults]) -> Void ) {
        let url = BasicUrl.topRatedTV
        
        AF.request(url, method: .get, headers: Header.tbdb).responseDecodable(of: TMDBTop.self) { response in
            switch response.result {
            case .success(let success):
//                print(success)
                print(success)
                compliteHandler(success.results)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func petchPopularTV( compliteHandler : @escaping ([Populars]) -> Void ) {
        let url = "https://api.themoviedb.org/3/tv/popular" //BasicUrl.popularTV
        
        AF.request(url, method: .get, headers: Header.tbdb).responseDecodable(of: TMDBPopular.self) { response in
            switch response.result {
            case .success(let success):
//                print(success)
                compliteHandler(success.results)
            case .failure(let failure):
                print("✂️✂️✂️✂️✂️✂️")
                print(failure)
            }
        }
        
    }
    
    func petchTMDBTV (basicUrl: String, Type: String? , compliteHandler : @escaping (TMDBTVAll) -> Void ) {
        var url = basicUrl //BasicUrl.popularTV
        
//        if Type != nil{
//            url = url + Type!
//        }
        if let type = Type {
            url = url + type
        }
        
        AF.request(url, method: .get, headers: Header.tbdb).responseDecodable(of: TMDBTVAll.self) { response in
            switch response.result {
            case .success(let success):
//                print(success)
                compliteHandler(success)
            case .failure(let failure):
                print("✂️✂️✂️✂️✂️✂️")
                print(failure)
            }
        }
        
    }
    
}


