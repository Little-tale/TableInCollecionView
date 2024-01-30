// 만들고 나니 깨닳은 사실
// 모델이 다 같다.

import UIKit

struct TMDBTV :Decodable {
    let results : [Results]
}

struct Results: Decodable {
    let name: String
    let poster_path: String
}
///

struct TMDBTop : Decodable {
    
    let results : [TopResults]
}
struct TopResults: Decodable {
    
    let original_name: String
    let poster_path: String
}

///
struct TMDBPopular: Decodable {
    let results : [Populars]
    
}

struct Populars: Decodable {
    let original_name : String
    let poster_path : String?
}
