//
//  FeaturePlaylistCell.swift
//  SpotifyClone
//
//  Created by Warln on 03/04/22.
//

import UIKit

class FeaturePlaylistCell: UICollectionViewCell {
    static let identifier = "FeaturePlaylistCell"
    
    private let posterImg: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "profile")
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private let playlistNameLbl: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 12, weight: .semibold)
        return lbl
    }()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        contentView.addSubview(posterImg)
        contentView.addSubview(playlistNameLbl)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageHeight = contentView.height - 30
        posterImg.frame = CGRect(
            x: 10,
            y: 0,
            width: contentView.width,
            height: imageHeight
        )
        playlistNameLbl.frame = CGRect(
            x: 5,
            y:  imageHeight + 10,
            width: contentView.width-3,
            height: 15
        )

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.posterImg.image = nil
        self.playlistNameLbl.text = nil
    }
    
    func configure(with viewModel: FeaturePlayViewModel ) {
        guard let url = viewModel.imageUrl else {return}
        posterImg.sd_setImage(with: url, completed: nil)
        playlistNameLbl.text = viewModel.name
    }
}
