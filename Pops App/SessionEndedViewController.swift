
import UIKit

class SessionEndedViewController: UIViewController {

    let viewModel = SessionEndedViewModel()
    
    lazy var viewWidth: CGFloat = self.view.frame.width
    lazy var viewHeight: CGFloat = self.view.frame.height
    
    let doneButton = UIButton()
    let extendHourButton = UIButton()
    let lineDividerView = UIView()
    let characterMessageHeader = UILabel()
    let characterMessageBody = UILabel()
    
    let coachWindowView = UIView()
    let coachIcon = UIImageView()
    
    let headerView = UIView()
    
    var coachBottomAnchorConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupDoneButton()
        setupExtendHourButton()
        setupLineDividerView()
        setupCharacterMessageBody()
        setupCharacterMessageHeader()
        selectSessionEndedState()
        setupCoachWindow()
        setupCoachIcon()
        setupHeaderView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateCoachPopup()
        
        if !(viewModel.dataStore.user.currentSession?.mightCancelSession)! {
            
            if viewModel.dataStore.user.currentSession != nil {
                viewModel.dataStore.user.currentSession?.sessionTimer.invalidate()
                let totalHours = viewModel.dataStore.defaults.value(forKey: "totalHours") as? Int ?? 0
                let sessionHours = viewModel.dataStore.user.currentSession!.sessionHours
                let newTotal = totalHours + sessionHours
                viewModel.dataStore.defaults.set(newTotal, forKey: "totalHours")
                viewModel.dataStore.user.currentSession = nil
            }
            
        }
    }
    
    func presentSetSessionVC() {
        if viewModel.dataStore.user.currentSession?.mightCancelSession == true {
            viewModel.dataStore.user.totalProps -= viewModel.dataStore.user.currentCoach.difficulty.basePenaltyForLeavingProductivityScreen
            
            if viewModel.dataStore.user.totalProps < 0 {
                viewModel.dataStore.user.totalProps = 0
            }
            
            viewModel.dataStore.user.currentSession = nil
        }
        
        viewModel.dataStore.defaults.set(false, forKey: "sessionActive")
        viewModel.dataStore.defaults.set(true, forKey: "returningUser")
        
        let setSessionVC = SetSessionViewController()
        present(setSessionVC, animated: true, completion: nil)
    }
    
    func presentProductiveTimeVC() {
        if viewModel.dataStore.user.currentSession?.mightCancelSession == true {
            dismiss(animated: true, completion: nil)
        } else {
            viewModel.dataStore.defaults.set(false, forKey: "sessionActive")
            viewModel.startSessionOfLength(1)
            let productiveTimeVC = ProductiveTimeViewController()
            present(productiveTimeVC, animated: true, completion: nil)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}

extension SessionEndedViewController {
    
    func selectSessionEndedState() {
        if viewModel.dataStore.user.currentSession?.mightCancelSession == true {
            doneButton.setTitle("cancel session", for: .normal)
            extendHourButton.setTitle("continue", for: .normal)
            characterMessageBody.text = "If you cancel this session early you will lose \(viewModel.dataStore.user.currentCoach.difficulty.basePenaltyForLeavingProductivityScreen) props. Are you sure you want to give up now?"
            characterMessageHeader.text = "Cancel session?"
        } else {
            doneButton.setTitle("let me go", for: .normal)
            extendHourButton.setTitle("extend for an hour", for: .normal)
            characterMessageBody.text = viewModel.dataStore.user.currentCoach.endSessionStatements[0].body
            characterMessageHeader.text = viewModel.dataStore.user.currentCoach.endSessionStatements[0].header
        }
    }
    
    func setupDoneButton() {
        doneButton.backgroundColor = Palette.lightGrey.color
        doneButton.setTitleColor(.black, for: .normal)
        doneButton.alpha = 1
        doneButton.isEnabled = true
        doneButton.layer.cornerRadius = 2.0
        doneButton.layer.masksToBounds = true
        doneButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 14.0)
        doneButton.setTitleColor(Palette.darkText.color, for: .normal)
        doneButton.addTarget(self, action: #selector(presentSetSessionVC), for: .touchUpInside)
        
        view.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        doneButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 269/viewWidth).isActive = true
        doneButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 45/viewHeight).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -viewHeight * (150/667.0)).isActive = true
    }
    
    func setupExtendHourButton() {
        extendHourButton.backgroundColor = Palette.lightBlue.color
        extendHourButton.layer.cornerRadius = 2.0
        extendHourButton.layer.masksToBounds = true
   
        extendHourButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 14.0)
        extendHourButton.addTarget(self, action: #selector(presentProductiveTimeVC), for: .touchUpInside)
        
        view.addSubview(extendHourButton)
        extendHourButton.translatesAutoresizingMaskIntoConstraints = false
        extendHourButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        extendHourButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 269/viewWidth).isActive = true
        extendHourButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 45/viewHeight).isActive = true
        extendHourButton.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -viewHeight * (15/667.0)).isActive = true
    }

    func setupLineDividerView() {
        lineDividerView.backgroundColor = Palette.lightGrey.color
        lineDividerView.layer.cornerRadius = 2.0
        lineDividerView.layer.masksToBounds = true
        
        view.addSubview(lineDividerView)
        lineDividerView.translatesAutoresizingMaskIntoConstraints = false
        lineDividerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lineDividerView.bottomAnchor.constraint(equalTo: extendHourButton.topAnchor, constant: -viewHeight * (25/viewHeight)).isActive = true
        lineDividerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 269/viewWidth).isActive = true
        lineDividerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 3/viewHeight).isActive = true
    }
    
    func setupCharacterMessageBody() {
        characterMessageBody.numberOfLines = 0
        characterMessageBody.textColor = Palette.grey.color
        characterMessageBody.textAlignment = .left
        characterMessageBody.font = UIFont(name: "Avenir-Heavy", size: 14.0)
       
        
        view.addSubview(characterMessageBody)
        characterMessageBody.translatesAutoresizingMaskIntoConstraints = false
        characterMessageBody.bottomAnchor.constraint(equalTo: lineDividerView.topAnchor, constant: -viewHeight * (20/viewHeight)).isActive = true
        characterMessageBody.leadingAnchor.constraint(equalTo: lineDividerView.leadingAnchor).isActive = true
        characterMessageBody.trailingAnchor.constraint(equalTo: lineDividerView.trailingAnchor).isActive = true
    }
    
    func setupCharacterMessageHeader() {
        characterMessageHeader.numberOfLines = 0
        characterMessageHeader.textColor = UIColor.black
        characterMessageHeader.textAlignment = .left
        characterMessageHeader.font = UIFont(name: "Avenir-Black", size: 14.0)
        
        
        view.addSubview(characterMessageHeader)
        characterMessageHeader.translatesAutoresizingMaskIntoConstraints = false
        characterMessageHeader.bottomAnchor.constraint(equalTo: characterMessageBody.topAnchor, constant: -viewHeight * (5/viewHeight)).isActive = true
        characterMessageHeader.leadingAnchor.constraint(equalTo: characterMessageBody.leadingAnchor).isActive = true
        characterMessageHeader.trailingAnchor.constraint(equalTo: characterMessageBody.trailingAnchor).isActive = true
    }
    
    func setupCoachWindow() {
        view.addSubview(coachWindowView)
        coachWindowView.translatesAutoresizingMaskIntoConstraints = false
        coachWindowView.backgroundColor = Palette.salmon.color
        coachWindowView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        coachWindowView.bottomAnchor.constraint(equalTo: characterMessageHeader.topAnchor, constant: -viewHeight * (40/667)).isActive = true
        coachWindowView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        coachWindowView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        coachWindowView.layer.cornerRadius = 50.0
        coachWindowView.layer.masksToBounds = true
    }
    
    func setupCoachIcon() {
        coachIcon.image = viewModel.dataStore.user.currentCoach.icon
        coachIcon.contentMode = .scaleAspectFill
        
        coachWindowView.addSubview(coachIcon)
        coachIcon.translatesAutoresizingMaskIntoConstraints = false
        
        coachBottomAnchorConstraint = coachIcon.bottomAnchor.constraint(equalTo: coachWindowView.bottomAnchor, constant: 100)
        coachBottomAnchorConstraint.isActive = true
        coachIcon.centerXAnchor.constraint(equalTo: coachWindowView.centerXAnchor, constant: 0).isActive = true
        coachIcon.heightAnchor.constraint(equalToConstant: 80).isActive = true
        coachIcon.widthAnchor.constraint(equalToConstant: 52).isActive = true
    }
    
    func setupHeaderView() {
        headerView.backgroundColor = Palette.salmon.color
        
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: viewHeight * (5/viewHeight)).isActive = true
        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
    
    func animateCoachPopup() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1) {
            self.coachBottomAnchorConstraint.constant = 10
            self.view.layoutIfNeeded()
        }
    }
}
