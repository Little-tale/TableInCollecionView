
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

    
    var tmdbAllList: [TMDBTVAll] = [
        TMDBTVAll(results: []),
        TMDBTVAll(results: []),
        TMDBTVAll(results: [])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        view.backgroundColor = .white
        configureHierarchy()
        configureLayout()
        designView()

        TMDBManager.shard.petchTMDBTV(basicUrl: TMDBManager.BasicUrl.trendTV, Type: TMDBManager.TrendType.day) { results in
            self.tmdbAllList[0] = results
            self.trendCollectionView.reloadData()
        }
        TMDBManager.shard.petchTMDBTV(basicUrl: TMDBManager.BasicUrl.topRatedTV, Type: nil) { results in
            self.tmdbAllList[1] = results
            self.topCollectionView.reloadData()
        }
        TMDBManager.shard.petchTMDBTV(basicUrl: TMDBManager.BasicUrl.popularTV, Type: nil) { results in
            self.tmdbAllList[2] = results
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
            
            collectionView.tag = 0
            
            return tmdbAllList[collectionView.tag].results.count
        } else if topCollectionView == collectionView {
            print("😡😡😡😡😡😡")
            collectionView.tag = 1
            return tmdbAllList[collectionView.tag].results.count
        } else {
            collectionView.tag = 2
            print("☝️☝️☝️☝️☝️☝️")
            return tmdbAllList[collectionView.tag].results.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        
        let tbdb = tmdbAllList[collectionView.tag].results[indexPath.item]
        
        let stringUrl = TMDBManager.BasicUrl.image
        let url = URL(string: stringUrl + (tbdb.poster_path ?? ""))
        cell.imageView.kf.setImage(with: url, placeholder: UIImage(systemName: "star"))
        cell.titleLabel.text = tbdb.original_name
        
        //cell.imageView.image = UIImage(systemName: testList[indexPath.item])
        //cell.titleLabel.text = testList[indexPath.item]
        //cell.backgroundColor = .gray
        
        return cell
    }
    
    
}


//#Preview {
//    ViewController()
//}
