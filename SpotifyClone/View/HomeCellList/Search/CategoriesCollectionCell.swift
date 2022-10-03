//
//  GenraCollectionCell.swift
//  SpotifyClone
//
//  Created by Warln on 15/05/22.
//

import UIKit
import SDWebImage

class CategoriesCollectionCell: UICollectionViewCell {
    static let identifier = "GenraCollectionCell"
    
    private let nameLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = .systemFont(ofSize: 18, weight: .semibold)
        return lbl
    }()
    
    private let posterImage : UIImageView = {
       let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.tintColor = .white
        image.image = UIImage(systemName: "music.quarternote.3", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular) )
        return image
    }()
    
    private var color: [UIColor] = [
        .systemPink,
        .systemRed,
        .systemBlue,
        .systemCyan,
        .darkGray,
        .systemMint,
        .systemTeal,
        .magenta,
        .systemYellow
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.addSubview(nameLbl)
        contentView.addSubview(posterImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLbl.frame = CGRect(x: 10, y: contentView.height/2, width: contentView.width - 20, height: contentView.height/2)
        posterImage.frame = CGRect(x: contentView.width/2, y: 10, width: contentView.width/2, height: contentView.height/2)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLbl.text = nil
        posterImage.image = UIImage(
            systemName: "music.quarternote.3",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular)
        )
    }
    
    func configure(with viewModel: CategoryViewModel) {
        nameLbl.text = viewModel.title
        posterImage.sd_setImage(with: viewModel.imgURl, completed: nil)
        contentView.backgroundColor = color.randomElement()
    }
    
    
}
