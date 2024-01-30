//
//  CustomCollectionViewCell.swift
//  TableInCollecionView
//
//  Created by Jae hyung Kim on 1/30/24.
//

import UIKit
import SnapKit

class CustomCollectionViewCell: UICollectionViewCell {
    let titleLabel = UILabel()
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        all()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        all()
    }
    func all(){
        configureHierarchy()
        configureLayout()
        designView()
    }
    
    func configureHierarchy(){
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
    }
    func configureLayout(){
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView)
            make.height.equalTo(contentView).inset(10)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.horizontalEdges.equalTo(imageView)
            make.height.equalTo(20)
        }
    }
    func designView(){
        imageView.backgroundColor = .cyan
        titleLabel.backgroundColor = .orange
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
    }
    
}
