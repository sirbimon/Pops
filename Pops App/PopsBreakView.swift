
import UIKit
import YouTubeiOSPlayerHelper

class PopsBreakView: UIView {

    let viewModel = PopsBreakViewModel()
    
    lazy var viewWidth: CGFloat = self.frame.width
    lazy var viewHeight: CGFloat = self.frame.height
    
    var player = YTPlayerView()
    var backButton = UIButton()
    var lineDividerView = UIView()
    var header = UILabel()
    var body = UILabel()
    var likeButton = UIButton()
    var dislikeButton = UIButton()
    var nextButton = UIButton()
    let blackOpaqueHeader = UIView()
        
    init(){
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = .white
        setUpYouTubePlayerView()
        setupBlackOpaqueHeader()
        setUpNextButton()
        setUpDislikeButton()
        setUpLikeButton()
        setUpLineDividerView()
        setUpHeader()
            
        NotificationCenter.default.addObserver(self, selector: #selector(viewIsBeingDismissed), name: NSNotification.Name(rawValue: "coachBreakViewIsBeingDismissed"), object: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func likeButtonTapped() {
        viewModel.userLikedVideo(completion: { (isVerified) in
            if isVerified{
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.1) {
                        self.likeButton.backgroundColor = Palette.navy.color
                    }
                }
            }
            else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "iCloudError"), object: self)
            }
        })
    }
    
    
    func dislikeButtonTapped() {
        viewModel.userDislikedVideo(completion: { (isVerified) in
            if isVerified {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.1) {
                        self.dislikeButton.backgroundColor = Palette.grey.color
                    }
                    self.nextButtonTapped()
                }
            }
            else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "iCloudError"), object: self)
            }
        })
    }
    
    
    func nextButtonTapped() {
        let newVideoIndex = viewModel.letPopsGetYouADifferentVideo()
        let newVideo = viewModel.manager.popsVideos[newVideoIndex]
        self.player.load(withVideoId: newVideo.id)
        
        viewModel.userLiked = false
        viewModel.userDisliked = false
        
        UIView.animate(withDuration: 0.2) {
            self.likeButton.backgroundColor = Palette.lightBlue.color
            self.dislikeButton.backgroundColor = Palette.lightGrey.color
            self.header.alpha = 0
            self.body.alpha = 0
        }
        
        self.header.text = newVideo.title
        self.body.text = newVideo.description
        
        UIView.animate(withDuration: 0.2) {
            self.header.alpha = 1
            self.body.alpha = 1
        }
    }
    
    func viewIsBeingDismissed() {
        player.pauseVideo()
    }
}

extension PopsBreakView {
    
    func setUpYouTubePlayerView(){
        let playerWidth = UIScreen.main.bounds.width
        let playerHeight = UIScreen.main.bounds.height / 3
        let playerFrame = CGRect(x: 0, y: 0, width: playerWidth, height: playerHeight)
        player = YTPlayerView(frame: playerFrame)
        
        viewModel.letPopsGetYouAVideo { (videoID) in
            DispatchQueue.main.async {
                self.player.load(withVideoId: videoID)
                let currentVideoIndex = self.viewModel.currentVideoIndex
                self.header.text = self.viewModel.manager.popsVideos[currentVideoIndex].title
                self.body.text = self.viewModel.manager.popsVideos[currentVideoIndex].description
            }
        }
        self.addSubview(self.player)
    }
}

extension PopsBreakView {
    
    func setupBlackOpaqueHeader() {
        blackOpaqueHeader.backgroundColor = UIColor.black
        blackOpaqueHeader.alpha = 0.3
        
        self.insertSubview(blackOpaqueHeader, aboveSubview: player)
        blackOpaqueHeader.translatesAutoresizingMaskIntoConstraints = false
        blackOpaqueHeader.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        blackOpaqueHeader.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        blackOpaqueHeader.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        blackOpaqueHeader.heightAnchor.constraint(equalToConstant: 59).isActive = true
    }
    
    func setUpHeader(){
        header.numberOfLines = 0
        header.textColor = UIColor.black
        header.textAlignment = .left
        header.font = UIFont(name: "Avenir-Black", size: 14.0)
        
        self.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        header.bottomAnchor.constraint(equalTo: lineDividerView.topAnchor, constant: -viewHeight * (30/667)).isActive = true
        header.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: headerLeadingContraint()).isActive = true
        header.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -headerLeadingContraint()).isActive = true
    }
    
    func setUpLineDividerView() {
        lineDividerView.backgroundColor = Palette.lightGrey.color
        lineDividerView.layer.cornerRadius = 2.0
        lineDividerView.layer.masksToBounds = true
        
        self.addSubview(lineDividerView)
        lineDividerView.translatesAutoresizingMaskIntoConstraints = false
        lineDividerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        lineDividerView.bottomAnchor.constraint(equalTo: likeButton.topAnchor, constant: -viewHeight * (33/667)).isActive = true
        lineDividerView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 269/viewWidth).isActive = true
        lineDividerView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 3/viewHeight).isActive = true
    }
    
    func setUpLikeButton() {
        likeButton.backgroundColor = Palette.lightBlue.color
        likeButton.alpha = 1
        likeButton.isEnabled = true
        likeButton.layer.cornerRadius = 2.0
        likeButton.layer.masksToBounds = true
        likeButton.setTitle("love this", for: .normal)
        likeButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 14.0)
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        self.addSubview(likeButton)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        likeButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 269/viewWidth).isActive = true
        likeButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 45/viewHeight).isActive = true
        likeButton.bottomAnchor.constraint(equalTo: dislikeButton.topAnchor, constant: -viewHeight * (15/viewHeight)).isActive = true
    }
    
    func setUpDislikeButton() {
        dislikeButton.backgroundColor = Palette.lightGrey.color
        dislikeButton.setTitleColor(.black, for: .normal)
        dislikeButton.alpha = 1
        dislikeButton.isEnabled = true
        dislikeButton.layer.cornerRadius = 2.0
        dislikeButton.layer.masksToBounds = true
        dislikeButton.setTitle("this sucks", for: .normal)
        dislikeButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 14.0)
        dislikeButton.setTitleColor(Palette.darkText.color, for: .normal)
        dislikeButton.addTarget(self, action: #selector(dislikeButtonTapped), for: .touchUpInside)
        
        self.addSubview(dislikeButton)
        dislikeButton.translatesAutoresizingMaskIntoConstraints = false
        dislikeButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dislikeButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 269/viewWidth).isActive = true
        dislikeButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 45/viewHeight).isActive = true
        dislikeButton.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -viewHeight * (100/667)).isActive = true
    }
    
    func setUpNextButton() {
        nextButton.backgroundColor = Palette.aqua.color
        nextButton.alpha = 1
        nextButton.isEnabled = true
        nextButton.setTitle("Next Video", for: .normal)
        nextButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 14.0)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        self.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        nextButton.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.097).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}

extension PopsBreakView {
    func screenHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
    func screenWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    func headerLeadingContraint() -> CGFloat {
        switch(self.screenHeight()) {
        case 568:
            return 24
        case 667:
            return 53
        default:
            return 53
        }
    }
}
