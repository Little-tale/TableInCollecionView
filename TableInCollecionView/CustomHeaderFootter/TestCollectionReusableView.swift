//
//  TestCollectionReusableView.swift
//  TableInCollecionView
//
//  Created by Jae hyung Kim on 1/30/24.
//

import UIKit
import SnapKit

class TestCollectionReusableView: UICollectionReusableView {
    
    static let reuseIdentifier = "TestCollectionReusableView"
    
    lazy var horCollView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    
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
        self.addSubview(horCollView)
    }
    func configureLayout(){
        horCollView.snp.makeConstraints { make in
            make.verticalEdges.horizontalEdges.equalTo(self)
        }
    }
    func designView(){
        
    }
}
