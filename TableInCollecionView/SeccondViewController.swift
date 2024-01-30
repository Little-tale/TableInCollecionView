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
    
    var tmdbAllList: [TMDBTVAll] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(#function)
        view.backgroundColor = .white
        all()
        
        TMDBManager.shard.petchTMDBTV(basicUrl: TMDBManager.BasicUrl.trendTV, Type: TMDBManager.TrendType.day) { results in
            self.tmdbAllList.append(results)
            self.oneCollecionView.reloadData()
        }
       
        TMDBManager.shard.petchTMDBTV(basicUrl: TMDBManager.BasicUrl.topRatedTV , Type: nil) { results in
            self.tmdbAllList.append(results)
            self.oneCollecionView.reloadData()
        }
        
        TMDBManager.shard.petchTMDBTV(basicUrl: TMDBManager.BasicUrl.popularTV, Type: nil) { results in
            self.tmdbAllList.append(results)
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
        // 헤더뷰 등록 -> forSupplementaryViewOfKind: 어떤종류의 헤더뷰인지
        //
        oneCollecionView.register(TestCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TestCollectionReusableView")
        
        
    }
    
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: 80 , height: 160)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        layout.scrollDirection = .vertical
        
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
        cell.titleLabel.text = tmdbAllList[indexPath.section].results[indexPath.item].original_name
        
        
        return cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print("섹션 갯수",tmdbAllList.count)
        return tmdbAllList.count
    }
    
    // MARK: 헤더뷰 추가하는 메서드 제공해줌 -> 근데 호출이 안됨 왜지 = 크기 안정해서
    // -> 헤더가 4개 나옴 -> 섹션 개수를 테스트 -> 내가 4개 선언했음
    // 유동적 갯수로 전환 V -> 테스트라고 적은대를 각 Tag에 해당하는거 배출
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        print(kind) // UICollectionElementKindSectionHeader 만 나옴
        
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TestCollectionReusableView", for: indexPath) as! TestCollectionReusableView
        var headerText = "FREE"
        if let tag = TMDBManager.TMDBTag.from(tagNum: indexPath.section) {
            headerText = tag.getTMDBTagString()
        }
        
        reusableView.headerLabel.text = headerText
        
        return reusableView
    }

}
// UICollectionViewFlowLayout X
// MARK: - 헤더뷰 높이 지정하는법
extension SeccondViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let headerHeight = CGSize(width: collectionView.bounds.width , height: 28)
        return headerHeight
    }
}

//#Preview{
//    SeccondViewController()
//}
