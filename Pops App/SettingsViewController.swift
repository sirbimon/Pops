
import UIKit

struct SettingsObj {
    let icon: UIImage
    let text: String
}

class SettingsViewController: UIViewController, DisplayBreakTimerDelegate, SettingsViewModelDelegate {


    var viewModel: SettingsViewModel! = nil
    
    lazy var viewWidth: CGFloat = self.view.frame.width  //375
    lazy var viewHeight: CGFloat = self.view.frame.height  //667
    
    //reactive timer properties
    var settingsTimerCounter = 0 {
        didSet {
            settingsTotalTimerLabel.text = "\(formatTime(time: settingsTimerCounter)) left"
        }
    }
    
    //view properties
    let endBreakView = UIView()
    let endBreakViewLabelLeft = UILabel()
    var breakTimerLabel = UILabel()
    let endSessionView = UIView()
    let endSessionLabelLeft = UILabel()
    var settingsTotalTimerLabel = UILabel()

    let settingsOne = SettingsObj(icon: #imageLiteral(resourceName: "IC_ContactUs"), text: "contact us")
    let settingsTwo = SettingsObj(icon: #imageLiteral(resourceName: "IC_SharePops"), text: "share pops")
    let divider1 = UIView()
    let divider2 = UIView()
    let divider3 = UIView()
    let divider4 = UIView()
    let propsHoursView = UIView()
    let totalPropsLabel = UILabel()
    let propsLabel = UILabel()
    let totalHoursLabel = UILabel()
    let hoursProductiveLabel = UILabel()
    let progressBar = UIView()
    var progressBarWidth = NSLayoutConstraint()
    var stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = SettingsViewModel(vc: self)
        view.backgroundColor = UIColor.white
        setupPropsHoursView()
        setupStackView()
        setupEndSessionView()
        setupEndBreakView()
        
        if let sessionCounter = viewModel.dataStore.user.currentSession?.sessionTimerCounter {
            settingsTimerCounter = sessionCounter
        }
        
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

//view setups
extension SettingsViewController {
    
    func setupPropsHoursView() {
        propsHoursView.translatesAutoresizingMaskIntoConstraints = false
        propsHoursView.addSubview(totalPropsLabel)
        propsHoursView.addSubview(propsLabel)
        propsHoursView.addSubview(totalHoursLabel)
        propsHoursView.addSubview(hoursProductiveLabel)
        
        propsHoursView.heightAnchor.constraint(equalToConstant: viewHeight * (30/667)).isActive = true
        propsHoursView.widthAnchor.constraint(equalToConstant: viewWidth * (300/375)).isActive = true
        
        totalPropsLabel.text = String(viewModel.dataStore.user.totalProps)
        totalPropsLabel.font = UIFont(name: "Avenir-Heavy", size: 13)
        totalPropsLabel.translatesAutoresizingMaskIntoConstraints = false
        totalPropsLabel.topAnchor.constraint(equalTo: propsHoursView.topAnchor, constant: 0).isActive = true
        totalPropsLabel.leadingAnchor.constraint(equalTo: propsHoursView.leadingAnchor, constant: 0).isActive = true
        //totalPropsLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        propsLabel.text = "props"
        propsLabel.font = UIFont(name: "Avenir-Heavy", size: 13)
        propsLabel.textColor = Palette.aqua.color
        propsLabel.translatesAutoresizingMaskIntoConstraints = false
        propsLabel.topAnchor.constraint(equalTo: totalPropsLabel.bottomAnchor, constant: 0).isActive = true
        //propsLabel.widthAnchor.constraint(equalTo: totalPropsLabel.widthAnchor, constant: 0).isActive = true
        propsLabel.leadingAnchor.constraint(equalTo: propsHoursView.leadingAnchor, constant: 0).isActive = true
        
        totalHoursLabel.text = "200"
        totalHoursLabel.font = UIFont(name: "Avenir-Heavy", size: 13)
        totalHoursLabel.translatesAutoresizingMaskIntoConstraints = false
        totalHoursLabel.centerYAnchor.constraint(equalTo: totalPropsLabel.centerYAnchor, constant: 0).isActive = true
        totalHoursLabel.leadingAnchor.constraint(equalTo: totalPropsLabel.trailingAnchor, constant: 25).isActive = true
        //totalHoursLabel.widthAnchor.constraint(equalToConstant: viewWidth * (50 / )).isActive = true
        //totalHoursLabel.heightAnchor.constraint(equalTo: totalPropsLabel.heightAnchor, constant: 0).isActive = true
        
        hoursProductiveLabel.text = "hours being productive"
        hoursProductiveLabel.font = UIFont(name: "Avenir-Heavy", size: 13)
        hoursProductiveLabel.textColor = Palette.aqua.color
        hoursProductiveLabel.translatesAutoresizingMaskIntoConstraints = false
        hoursProductiveLabel.centerYAnchor.constraint(equalTo: propsLabel.centerYAnchor, constant: 0).isActive = true
        hoursProductiveLabel.leadingAnchor.constraint(equalTo: totalHoursLabel.leadingAnchor, constant: 0).isActive = true
        //hoursProductiveLabel.heightAnchor.constraint(equalTo: propsLabel.heightAnchor, constant: 0).isActive = true
        //hoursProductiveLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 150).isActive = true
    }
    
    func setupStackView() {
        let customView = CustomSettingsView(settings: settingsOne)
        let secondView = CustomSettingsView(settings: settingsTwo)
        
        let dividers = [divider1, divider2, divider3, divider4]
        let stackedViews = [divider1, propsHoursView, divider2, customView, divider3, secondView, divider4]
        
        dividers.forEach {
            $0.backgroundColor = Palette.lightGrey.color
            $0.heightAnchor.constraint(equalToConstant: 3).isActive = true
            $0.layer.cornerRadius = 2.0
        }
        
        stackedViews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        customView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        secondView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        stackView = UIStackView(arrangedSubviews: stackedViews)
        
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.spacing = viewHeight * (32 / 667)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.widthAnchor.constraint(equalToConstant: viewWidth * (300 / 375)).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -viewHeight * (120 / 667)).isActive = true
    }
    
    func setupEndSessionView() {
        view.addSubview(endSessionView)
        endSessionView.backgroundColor = Palette.lightGrey.color
        endSessionView.translatesAutoresizingMaskIntoConstraints = false
        endSessionView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        endSessionView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        endSessionView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -20).isActive = true
        endSessionView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        endSessionView.layer.cornerRadius = 2
        
        endSessionView.addSubview(endSessionLabelLeft)
        endSessionLabelLeft.font = UIFont(name: "Avenir-Heavy", size: 13)
        endSessionLabelLeft.translatesAutoresizingMaskIntoConstraints = false
        endSessionLabelLeft.text = "end my session"
        endSessionLabelLeft.textColor = Palette.darkText.color
        
        endSessionLabelLeft.leadingAnchor.constraint(equalTo: endSessionView.leadingAnchor, constant: 15).isActive = true
        //endSessionLabelLeft.heightAnchor.constraint(equalToConstant: 17).isActive = true
        //endSessionLabelLeft.widthAnchor.constraint(equalTo: endSessionView.widthAnchor, multiplier: 0.4).isActive = true
        endSessionLabelLeft.centerYAnchor.constraint(equalTo: endSessionView.centerYAnchor, constant: 0).isActive = true
        
        endSessionView.addSubview(settingsTotalTimerLabel)
        settingsTotalTimerLabel.font = UIFont(name: "Avenir-Heavy", size: 13)
        settingsTotalTimerLabel.translatesAutoresizingMaskIntoConstraints = false
        settingsTotalTimerLabel.text = "left"
        settingsTotalTimerLabel.textColor = Palette.darkText.color
        settingsTotalTimerLabel.textAlignment = .right
        
        settingsTotalTimerLabel.trailingAnchor.constraint(equalTo: endSessionView.trailingAnchor, constant: -15).isActive = true
        //settingsTotalTimerLabel.heightAnchor.constraint(equalToConstant: 17).isActive = true
        //settingsTotalTimerLabel.widthAnchor.constraint(equalTo: endSessionView.widthAnchor, multiplier: 0.4).isActive = true
        settingsTotalTimerLabel.centerYAnchor.constraint(equalTo: endSessionView.centerYAnchor, constant: 0).isActive = true
    }
    
    func setupEndBreakView() {
        view.addSubview(endBreakView)
        endBreakView.backgroundColor = Palette.purple.color
        endBreakView.translatesAutoresizingMaskIntoConstraints = false
        endBreakView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        endBreakView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        endBreakView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        endBreakView.bottomAnchor.constraint(equalTo: endSessionView.topAnchor, constant: -20).isActive = true
        endBreakView.layer.cornerRadius = 2
        
        endBreakView.addSubview(endBreakViewLabelLeft)
        endBreakViewLabelLeft.font = UIFont(name: "Avenir-Heavy", size: 13)
        endBreakViewLabelLeft.translatesAutoresizingMaskIntoConstraints = false
        endBreakViewLabelLeft.text = "end my break"
        endBreakViewLabelLeft.textColor = UIColor.white
        
        endBreakViewLabelLeft.leadingAnchor.constraint(equalTo: endBreakView.leadingAnchor, constant: 15).isActive = true
        //endBreakViewLabelLeft.heightAnchor.constraint(equalToConstant: 17).isActive = true
        //endBreakViewLabelLeft.widthAnchor.constraint(equalTo: endBreakView.widthAnchor, multiplier: 0.4).isActive = true
        endBreakViewLabelLeft.centerYAnchor.constraint(equalTo: endBreakView.centerYAnchor, constant: 0).isActive = true
        
        endBreakView.addSubview(breakTimerLabel)
        breakTimerLabel.font = UIFont(name: "Avenir-Heavy", size: 13)
        breakTimerLabel.translatesAutoresizingMaskIntoConstraints = false
        breakTimerLabel.text = "left"
        breakTimerLabel.textColor = UIColor.white
        breakTimerLabel.textAlignment = .right
        
        breakTimerLabel.trailingAnchor.constraint(equalTo: endBreakView.trailingAnchor, constant: -15).isActive = true
        //breakTimerLabel.heightAnchor.constraint(equalToConstant: 17).isActive = true
        //breakTimerLabel.widthAnchor.constraint(equalTo: endBreakView.widthAnchor, multiplier: 0.4).isActive = true
        breakTimerLabel.centerYAnchor.constraint(equalTo: endBreakView.centerYAnchor, constant: 0).isActive = true
    }
}

extension SettingsViewController {
    
    //helper method
    func formatTime(time: Int) -> String {
        if time >= 3600 {
            let hours = time / 3600
            let minutes = time / 60 % 60
            let seconds = time % 60
            return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
            
        } else if time >= 60 {
            
            let minutes = time / 60 % 60
            let seconds = time % 60
            return String(format:"%02i:%02i", minutes, seconds)
            
        } else {
            let seconds = time % 60
            return String(format:"%02i", seconds)
        }
    }
}

