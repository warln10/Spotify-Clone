//
//  NewReleaseCell.swift
//  SpotifyClone
//
//  Created by Warln on 03/04/22.
//

import UIKit
import SDWebImage

class NewReleaseCell: UICollectionViewCell {
    static let identifier = "NewReleaseCell"
    
    private let posterImg: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "profile")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let albumNameLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 20, weight: .semibold)
        return lbl
    }()
    
    private let numberOfTrackLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 15, weight: .thin)
        return lbl
    }()
    
    private let artistNameLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 18, weight: .light)
        return lbl
    }()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(posterImg)
        contentView.addSubview(albumNameLbl)
        contentView.addSubview(numberOfTrackLbl)
        contentView.addSubview(artistNameLbl)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize = contentView.height - 10
        let alblumSize = albumNameLbl.sizeThatFits(CGSize(width: contentView.width-imageSize-10, height: contentView.height-10))
        let albumHeight = min(60, alblumSize.height)
        numberOfTrackLbl.sizeToFit()
        artistNameLbl.sizeToFit()
        posterImg.frame = CGRect(x: 5, y: 5, width: imageSize, height: imageSize)
        albumNameLbl.frame = CGRect(
        x: posterImg.right + 10,
            y: 5,
            width: alblumSize.width,
            height: albumHeight
        )
        artistNameLbl.frame = CGRect(
            x: posterImg.right+10,
            y: albumNameLbl.bottom,
            width: contentView.width - posterImg.right-10,
            height: 30
        )
        
        numberOfTrackLbl.frame = CGRect(
            x: posterImg.right + 10,
            y: contentView.bottom - 44,
            width: numberOfTrackLbl.width,
            height: 44)

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.posterImg.image = nil
        self.albumNameLbl.text = nil
        self.numberOfTrackLbl.text = nil
        self.artistNameLbl.text = nil
    }
    
    func configure(with viewModel: NewReleaseViewModel ) {
        guard let url = viewModel.imageUrl else {return}
        posterImg.sd_setImage(with: url, completed: nil)
        albumNameLbl.text = viewModel.name
        numberOfTrackLbl.text = "Tracks: \(viewModel.numberOfTrack)"
        artistNameLbl.text = viewModel.artistName
    }
    
}
