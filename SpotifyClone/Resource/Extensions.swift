//
//  Extensions.swift
//  SpotifyClone
//
//  Created by Warln on 27/03/22.
//

import UIKit

extension UIView {
    
    var width: CGFloat {
        return frame.width
    }
    
    var height: CGFloat {
        return frame.height
    }
    
    var left: CGFloat {
        return frame.origin.x
    }
    
    var right: CGFloat {
        return left + width
    }
    
    var top: CGFloat {
        return frame.origin.y
    }
    
    var bottom: CGFloat {
        return top + height
    }
    
}

extension String {
    func capitalziedFirst() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    static func formattedDate(with data: String) -> String {
        guard let date = DateFormatter.dateFormatter.date(from: data) else {
            return data
        }
        return DateFormatter.displayDate.string(from: date)
    }
}

extension DateFormatter {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }()
    
    static let displayDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}
