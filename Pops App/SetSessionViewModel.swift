
import Foundation
import UIKit

final class SetSessionViewModel {
    
    static let singleton = SetSessionViewModel()
    
    let dataStore = CoachesDataStore.singleton
    
    let timesForCollectionView = [Time("1 hour"), Time("2 hours"), Time("3 hours"), Time("4 hours"), Time("5 hours"), Time("6 hours"), Time("7 hours"), Time("8 hours")]
    
    let sessionCoach: Coach!
    
    
    private init(){
        self.sessionCoach = dataStore.getCurrentCoach()
    }
 
}

final class Time {
    let string: String
    var isSelected = false
    
    init(_ string: String) {
        self.string = string
    }
    
//    var hashValue: Int {
//        return string.hashValue
//        
//    }
//    
//    static func ==(lhs: Time, rhs: Time) -> Bool {
//        return lhs.string == rhs.string
//    }
    
}

class HourCollectionViewCell: UICollectionViewCell {
    
    let hourLabel = UILabel()
    
    var time: Time! {
        didSet {
            hourLabel.text = time.string
            timeIsSelected = time.isSelected
            contentView.backgroundColor = time.isSelected ?  Palette.darkHeader.color : Palette.lightBlue.color
        }
    }
    
//    var time: String! {
//        didSet {
//            hourLabel.text = time
//            contentView.backgroundColor = timeIsSelected ?  Palette.darkHeader.color : Palette.lightBlue.color
//        }
//    }
    
    var timeIsSelected = false {
        didSet {
            time.isSelected = timeIsSelected
            contentView.backgroundColor = time.isSelected ?  Palette.darkHeader.color : Palette.lightBlue.color
        }
    }
    
    func resetBackground() {
        contentView.backgroundColor = Palette.lightBlue.color
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupLabel() {
        hourLabel.textColor = UIColor.white
        hourLabel.font = UIFont(name: "Avenir-Medium", size: 14.0)
        
        contentView.addSubview(hourLabel)
        hourLabel.translatesAutoresizingMaskIntoConstraints = false
        hourLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        hourLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hourLabel.text = nil
    }

}