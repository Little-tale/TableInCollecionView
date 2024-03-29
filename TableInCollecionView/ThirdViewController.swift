/*
 급하게 3단계로 넘어왔다
 UIColReus 어쩌고 너무 어렵다.
 3단계 마치면 하러 가겠다.
 */
import UIKit
import SnapKit
import Kingfisher

class ThirdViewController: UIViewController {
    // 1. 테이블뷰 추가
    let tableContentView = UITableView()
    // lazy var colView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    
    // 이게 고정적인 느낌이 있는데 차라리 정해진 갯수가 없고 그 값에 따라
    // 유동적으로 섹션이 생기면 좋지 않을까?
    
    var allData: [TMDBTVAll] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        all()
        
        
        TMDBManager.shard.petchTMDBTV(basicUrl: TMDBManager.BasicUrl.trendTV, Type: TMDBManager.TrendType.day) { results in
            self.allData.append(results)
            self.tableContentView.reloadData()
        }
        TMDBManager.shard.petchTMDBTV(basicUrl: TMDBManager.BasicUrl.topRatedTV, Type: nil) { results in
            self.allData.append(results)
            self.tableContentView.reloadData()
        }
        TMDBManager.shard.petchTMDBTV(basicUrl: TMDBManager.BasicUrl.popularTV, Type: nil) { results in
            self.allData.append(results)
            self.tableContentView.reloadData()
            
            // print(self.allData)
        }
        
    }
    
    
    func all(){
        configureHierarchy()
        configureLayout()
        designView()
        
        navigationItem.title = "3단계"
    }
    
    func configureHierarchy(){
        view.addSubview(tableContentView)
    }
    func configureLayout(){
        tableContentView.snp.makeConstraints { make in
            make.verticalEdges.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    func designView(){
        tableContentView.backgroundColor = .green
        
        tableContentView.delegate = self
        tableContentView.dataSource = self
        
        tableContentView.register(CustomTableTableViewCell.self, forCellReuseIdentifier: "CustomTableTableViewCell")
        
        tableContentView.estimatedRowHeight = 200 
        tableContentView.rowHeight = UITableView.automaticDimension
        tableContentView.backgroundColor = .lightGray
    }
    

}

//MARK: - 테이블뷰가 사실상 Section -> 3개가 나오면 된다.
extension ThirdViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableTableViewCell", for: indexPath) as! CustomTableTableViewCell
        
        cell.collecionView.delegate = self
        cell.collecionView.dataSource = self
        cell.collecionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCollectionViewCell")
        
        print("테이블 뷰의 로우가 내 아들의 섹션 : ",indexPath.row)
        // -> 테이블뷰의 로우가 컬의 섹션이 될수 있겠다.
        
        //MARK: 자식컬렉션에 태그를 넣어 근데 이 태그가 유동적으로 처리하게끔 한번 해보고싶다.
        cell.collecionView.tag = indexPath.row
        
        
        if let tagName = TMDBManager.TMDBTag.from(tagNum: indexPath.row) {
            cell.titleLabel.text = tagName.getTMDBTagString()
        }
        
        cell.collecionView.reloadData()
        
        return cell
    }
    
    
}
//MARK: - 컬렉션뷰는 items에 속한다고 생각
extension ThirdViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("데이터가 없니??", allData[collectionView.tag].results.count)
        return allData[collectionView.tag].results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        cell.backgroundColor = .brown
        
        print("난 아들인데 번호가..? ",collectionView.tag)
        
        let urlString = TMDBManager.BasicUrl.image + (allData[collectionView.tag].results[indexPath.item].poster_path ?? "")
        let url = URL(string: urlString)
        
        cell.imageView.kf.setImage(with: url , placeholder: UIImage(systemName: "star"))
        
        cell.titleLabel.text = allData[collectionView.tag].results[indexPath.item].original_name
        
        // MARK: - 순서가 컬렉션 뷰의 갯수가 정해진후 값이 들어온다 그래서... 테이블 뷰가 리로드 해주어야 할것같다.
        return cell
    }
    
    
}
