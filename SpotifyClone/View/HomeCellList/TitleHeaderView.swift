//
//  TitleHeaderView.swift
//  SpotifyClone
//
//  Created by Warln on 08/05/22.
//

import UIKit

class TitleHeaderView: UICollectionReusableView {
    static let identifier = "TitleHeaderView"
    
    private let titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.numberOfLines = 1
        lbl.font = .systemFont(ofSize: 18, weight: .semibold)
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLbl)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLbl.frame = CGRect(x: 10, y: 0, width: width-30, height: height)
    }
    
    func configure(with title: String) {
        titleLbl.text = title
    }
        
}
