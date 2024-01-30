/*
 2단계 
 하나의 뷰 컨트롤러에 컬렉션뷰 1개를 추가
 컬렉션뷰를 섹션(재사용 뷰 ) 를 나누어 API 호툴해 보기
 
 */

import UIKit
import SnapKit
import Kingfisher

class SeccondViewController: UIViewController {
    //1. 하나의 뷰 컨트롤러에 컬렉션뷰 하나 추가
    lazy var oneCollecionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    var tmdbAllList: [TMDBTVAll] = [
        TMDBTVAll(results: []),
        TMDBTVAll(results: []),
        TMDBTVAll(results: []),
        TMDBTVAll(results: [])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(#function)
        view.backgroundColor = .white
        all()
        
        TMDBManager.shard.petchTMDBTV(basicUrl: TMDBManager.BasicUrl.trendTV, Type: TMDBManager.TrendType.day) { results in
            self.tmdbAllList[TMDBManager.TMDBTag.trendTV.rawValue] = results
            self.oneCollecionView.reloadData()
        }
       
        TMDBManager.shard.petchTMDBTV(basicUrl: TMDBManager.BasicUrl.topRatedTV , Type: nil) { results in
            self.tmdbAllList[TMDBManager.TMDBTag.topRatedTV.rawValue] = results
            self.oneCollecionView.reloadData()
        }
        TMDBManager.shard.petchTMDBTV(basicUrl: TMDBManager.BasicUrl.popularTV, Type: nil) { results in
            self.tmdbAllList[TMDBManager.TMDBTag.popularTV.rawValue] = results
            self.oneCollecionView.reloadData()
        }
        
    }
    
    func all(){
        configureHierarchy()
        configureLayout()
        designView()
    }
    
    func configureHierarchy(){
        //1.
        view.addSubview(oneCollecionView)
    }
    func configureLayout(){
        oneCollecionView.snp.makeConstraints { make in
            make.verticalEdges.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    func designView(){
        oneCollecionView.backgroundColor = .blue
        oneCollecionView.dataSource = self
        oneCollecionView.delegate = self
        
        oneCollecionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCollectionViewCell")
       
    }
    
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width , height: 180)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        layout.scrollDirection = .horizontal
        
        return layout
    }
    
}


extension SeccondViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tmdbAllList[section].results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        if indexPath.section == 0 {
            cell.backgroundColor = .red
        } else if indexPath.section == 1 {
            cell.backgroundColor = .green
        } else {
            cell.backgroundColor = .brown
        }
        let urlString = TMDBManager.BasicUrl.image + (tmdbAllList[indexPath.section].results[indexPath.item].poster_path ?? "")
        
        let url = URL(string: urlString)
        
        cell.imageView.kf.setImage(with: url)
        
        return cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return tmdbAllList.count
    }
    
}

//#Preview{
//    SeccondViewController()
//}
