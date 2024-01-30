//
//  TestCollectionReusableView.swift
//  TableInCollecionView
//
//  Created by Jae hyung Kim on 1/30/24.
//

import UIKit
import SnapKit

class TestCollectionReusableView: UICollectionReusableView {
    
    lazy var horCollView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    let headerLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        all()
    }
    
    func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 150)
        return layout
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func all(){
        configureHierarchy()
        configureLayout()
        designView()
        
       
    }
    func configureHierarchy(){
       // self.addSubview(horCollView)
        self.addSubview(headerLabel)
    }
    func configureLayout(){
//        horCollView.snp.makeConstraints { make in
//            make.verticalEdges.horizontalEdges.equalTo(self)
//        }
        
        headerLabel.snp.makeConstraints { make in
            make.verticalEdges.horizontalEdges.equalTo(self)
        }
    }
    func designView(){
        self.backgroundColor = .lightGray
    }
}
