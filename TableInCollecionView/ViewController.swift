
/*
 1. 하나의 뷰 컨트롤러에 컬렉션뷰 3개를 추가후 각 컬렉션뷰에 Trend / Top Rated / Populer 연동 작업하기
 2. 하나의 뷰 컨트롤러에 컬렉션뷰 1개를 추가하고  컬렉션뷰를 섹션(UICollectionReusableView) 을 나누어 API 3개 호출해 보기
 3. 수업에서 구현했던 유아이 유사하게 , 컬렉션뷰를 추가해서 API 3개 동시 호출
 */


//1. 일단 UI 어떻게 할건지 세팅

import UIKit
import SnapKit
import Kingfisher

// 1번 과제
class ViewController: UIViewController {
    
    lazy var trendCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout() )
    lazy var topCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout() )
    lazy var populerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout() )
    
    // 1. UI구성 V
    // 2. 더미데이터로 테스트 V
    // 3. API 모델링 1. V 2.  3.
    // 모델링을 다해보니 모양이 같아서 같은 모델 재사용
    
    let testList = ["star","star.fill","star","star.fill","star","star.fill","star","star.fill"]
    var tmdbList: [Results] = []
    var tmdbTopList: [TopResults] = []
    var tmdbPopList: [Populars] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        view.backgroundColor = .white
        configureHierarchy()
        configureLayout()
        designView()
        TMDBManager.shard.petchTrendTV(TrendType: TMDBManager.TrendType.day) { TMDBTV in
            self.tmdbList = TMDBTV
            // 값 전달 받는지 테스트 V
            // print(self.tmdbList)
            // 트렌드 콜렉션뷰 리로드
            self.trendCollectionView.reloadData()
        }
        // API 2번째 테스트 시작 1. 통신 성공 V 2. 값 전달
        TMDBManager.shard.petchTVTopRated { TopResults in
            self.tmdbTopList = TopResults
            // print(TopResults)
            self.topCollectionView.reloadData()
        }
        TMDBManager.shard.petchPopularTV { result in
            self.tmdbPopList = result
            print(self.tmdbPopList)
            self.populerCollectionView.reloadData()
        }
        
      
    }
    
    func configureHierarchy() {
        view.addSubview(trendCollectionView)
        view.addSubview(topCollectionView)
        view.addSubview(populerCollectionView)
    }
    func configureLayout() {
        trendCollectionView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(180)
        }
        topCollectionView.snp.makeConstraints { make in
            make.top.equalTo(trendCollectionView.snp.bottom).inset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(trendCollectionView)
        }
        populerCollectionView.snp.makeConstraints { make in
            make.top.equalTo(topCollectionView.snp.bottom).inset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(topCollectionView)
        }
    }
    func designView() {
        trendCollectionView.backgroundColor = .green
        topCollectionView.backgroundColor = .blue
        populerCollectionView.backgroundColor = .red
        
        trendCollectionView.delegate = self
        topCollectionView.delegate = self
        populerCollectionView.delegate = self
        
        trendCollectionView.dataSource = self
        topCollectionView.dataSource = self
        populerCollectionView.dataSource = self
        
        trendCollectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCollectionViewCell")
        topCollectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCollectionViewCell")
        populerCollectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCollectionViewCell")
        
        trendCollectionView.isPagingEnabled = true

    }


}

extension ViewController {
    func collectionViewLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 120)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        layout.scrollDirection = .horizontal
        
        return layout
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if trendCollectionView == collectionView {
            
            print("테스트!!!!!!!")
            
            return tmdbList.count
        } else if topCollectionView == collectionView {
            
            print("😡😡😡😡😡😡")
            return tmdbTopList.count
        } else {
            
            print("☝️☝️☝️☝️☝️☝️")
        }
        
        return tmdbList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        
        if topCollectionView == collectionView {
            let tmdbTop = tmdbTopList[indexPath.item]
            let urlString = TMDBManager.BasicUrl.image + tmdbTop.poster_path
            let url = URL(string: urlString)
            
            cell.imageView.kf.setImage(with: url, placeholder: UIImage(systemName: "star"))
            cell.titleLabel.text = tmdbTop.original_name
            return cell
            
        } else if populerCollectionView == collectionView {
            
            let tmdbpoplist = tmdbPopList[indexPath.item]
            let urlString = TMDBManager.BasicUrl.image + (tmdbpoplist.poster_path ?? "")
            let url = URL(string: urlString)
            cell.imageView.kf.setImage(with: url)
            cell.titleLabel.text = tmdbpoplist.original_name
            
            return cell
        }
        
        let urlString = TMDBManager.BasicUrl.image + tmdbList[indexPath.item].poster_path
        
        let url = URL(string: urlString)
        cell.imageView.kf.setImage(with: url,placeholder: UIImage(systemName: "star"))
        cell.titleLabel.text = tmdbList[indexPath.item].name
        
        //cell.imageView.image = UIImage(systemName: testList[indexPath.item])
        //cell.titleLabel.text = testList[indexPath.item]
        //cell.backgroundColor = .gray
        return cell
    }
    
    
}


//#Preview {
//    ViewController()
//}
