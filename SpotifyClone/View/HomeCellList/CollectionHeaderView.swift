//
//  CollectionHeaderView.swift
//  SpotifyClone
//
//  Created by Warln on 01/05/22.
//

import UIKit
import SDWebImage

protocol CollectionHeaderViewDelegate: AnyObject {
    func CollectionHeaderViewDidTapPlayAll(_ header: CollectionHeaderView)
}

class CollectionHeaderView: UICollectionReusableView {
    static let identifier = "CollectionHeaderView"
    
    private let posterImg: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.image = UIImage(systemName: "photo")
        return img
    }()
    
    private let nameLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 25, weight: .semibold)
        return lbl
    }()
    
    private let descriptionLBl: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 15, weight: .regular)
        lbl.numberOfLines = 0
        lbl.textColor = .secondaryLabel
        return lbl
    }()
    
    private let artristName: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 15, weight: .light)
        lbl.textColor = .secondaryLabel
        return lbl
    }()
    
    private let playBtn: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        let image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemGreen
        return button
    }()
    
    weak var delegate: CollectionHeaderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(posterImg)
        addSubview(nameLbl)
        addSubview(descriptionLBl)
        addSubview(artristName)
        addSubview(playBtn)
        playBtn.addTarget(self, action: #selector(didTapPlayAll), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize = height/1.8
        posterImg.frame = CGRect(x: (width-imageSize)/2, y: 20, width: imageSize, height: imageSize)
        nameLbl.frame = CGRect(x: 10, y: posterImg.bottom + 5, width: width-20, height: imageSize/6)
        descriptionLBl.frame = CGRect(x: 10, y: nameLbl.bottom, width: width-20, height: imageSize/6)
        artristName.frame = CGRect(x: 10, y: descriptionLBl.bottom + 5, width: width-20, height: 20)
        playBtn.frame = CGRect(x: width-80, y: height-80, width: 60, height: 60)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    @objc
    private func didTapPlayAll() {
        delegate?.CollectionHeaderViewDidTapPlayAll(self)
    }
    
    func configure(with model: HeaderViewModel){
        guard let url = model.image else {return}
        posterImg.sd_setImage(with: url, completed: nil)
        nameLbl.text = model.name
        descriptionLBl.text = model.description
        artristName.text = model.artist
    }
    
}
