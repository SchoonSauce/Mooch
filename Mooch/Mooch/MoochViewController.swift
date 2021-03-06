//
//  MoochViewController.swift
//  Mooch
//
//  Created by adam on 9/5/16.
//  Copyright © 2016 cse498. All rights reserved.
//

import Alamofire
import UIKit

//The base navigation controllers shouldn't rotate
extension UINavigationController {
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
}

//The base tab bar controllers shouldn't rotate
extension UITabBarController {
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
}

//Base class view controller
class MoochViewController: UIViewController {
    
    // MARK: Public variables
    
    //Flag for whether or this this view controller will need a network connection
    var requiresNetworkReachability = true
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    //Allows subclasses to know if the overlay is being shown
    var isShowingLoadingOverlay = false
    
    //Allows subclasses to know if the success alert is being shown
    var isShowingSuccessAlert = false
    
    
    // MARK: Private variables
    
    private let LoadingOverlayAnimationDuration = 0.1
    
    //Flag for whether or not the network reachability verification view controller is being shown
    fileprivate var isShowingNetworkReachabilityVerificationViewController = false
    
    //The view controller that is shown while the network reachability is being established
    fileprivate var networkReachabilityVerificationViewController: UIViewController?
    
    //The network reachability manager used to observe network reachability changes
    fileprivate var reachabilityManager: NetworkReachabilityManager!
    
    //Used to restore previous status bar style if changed for this view controller
    fileprivate var statusBarStyleBeforeChanging: UIStatusBarStyle?
    
    private(set) var loadingOverlayViewBeingShown: LoadingOverlayView?
    
    private(set) var successAlertBeingShown: SuccessAlertView?
    
    
    // MARK: Actions
    
    // MARK: Public methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        captureStatusBarStyle()
        updateStatusBarStyle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupReachabilityManager()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if requiresNetworkReachability && !reachabilityManager.isReachable {
            presentNetworkReachabilityVerificationViewController()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        restoreStatusBarStyle()
    }
    
    //Performs any actions that need to be taken once the view has been loaded
    //Should be overridden by subclasses
    func setup() { }
    
    //Performs any actions that need to be taken once the network connectivity has been established
    //Should be overridden by subclasses
    func didEstablishNetworkReachability() { }
    
    //Updates the UI based on current state. All UI changes should be handled here
    //Should be overridden by subclasses
    func updateUI() { }
    
    //Override this function to change the default preferred status bar style
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    //Override this function to change status bar animation behavior
    func shouldAnimateStatusBarChange() -> Bool {
        return true
    }
    
    func presentSuccessAlert(withInformationText informationText: String) {
        guard !isShowingSuccessAlert else { print("can't show two success views!"); return }
        
        isShowingSuccessAlert = true
        
        let successAlert = SuccessAlertView(frame: view.frame)
        successAlertBeingShown = successAlert
        
        //loadingOverlayViewBeingShown = loadingOverlayView
        successAlert.alpha = 0
        
        successAlert.setup(withInformationText: informationText) {
            self.hideSuccessAlert(animated: true)
        }
        
        UIApplication.shared.keyWindow?.addSubview(successAlert)
        
        UIView.animate(withDuration: 0.3) {
            successAlert.alpha = 1
        }
        
        successAlert.animateAlertOnScreen()
    }
    
    func hideSuccessAlert(animated: Bool) {
        guard let successAlert = successAlertBeingShown, isShowingSuccessAlert else { return }
        
        if animated {
            UIView.animate(withDuration: LoadingOverlayAnimationDuration, animations: { successAlert.alpha = 0 }, completion: { _ in
                self.hideSuccessAlert()
            })
        } else {
            hideSuccessAlert()
        }
    }
    
    private func hideSuccessAlert() {
        guard let successAlert = successAlertBeingShown else { return }
        successAlert.removeFromSuperview()
        isShowingSuccessAlert = false
        successAlertBeingShown = nil
    }
    
    func showLoadingOverlayView(withInformationText informationText: String?, overEntireWindow: Bool, withUserInteractionEnabled isUserInteractionEnabled: Bool, showingProgress showProgress: Bool, withHiddenAlertView hideAlertView: Bool) {
        guard !isShowingLoadingOverlay else { print("can't show two loadingOverlayViews!"); return }
        
        isShowingLoadingOverlay = true
        
        let loadingOverlayView = LoadingOverlayView(frame: view.frame)
        loadingOverlayViewBeingShown = loadingOverlayView
        loadingOverlayView.alpha = 0
        
        loadingOverlayView.setup(withInformationText: informationText, isUserInteractionEnabled: isUserInteractionEnabled, isProgressBased: showProgress, isAlertViewHidden: hideAlertView)
        
        if overEntireWindow {
            UIApplication.shared.keyWindow?.addSubview(loadingOverlayView)
        } else {
            view.addSubview(loadingOverlayView)
        }
        
        UIView.animate(withDuration: LoadingOverlayAnimationDuration) {
            loadingOverlayView.alpha = 1
        }
    }
    
    func hideLoadingOverlayView(animated: Bool, completion: (()->())? = nil) {
        guard let loadingOverlayView = loadingOverlayViewBeingShown, isShowingLoadingOverlay else { return }
        
        if animated {
            UIView.animate(withDuration: LoadingOverlayAnimationDuration, animations: { loadingOverlayView.alpha = 0 }, completion: { _ in
                self.hideOverlayView()
                completion?()
            })
        } else {
            hideOverlayView()
        }
    }
    
    private func hideOverlayView() {
        guard let loadingOverlayView = loadingOverlayViewBeingShown else { return }
        loadingOverlayView.removeFromSuperview()
        isShowingLoadingOverlay = false
        loadingOverlayViewBeingShown = nil
    }
    
    func presentSingleActionAlert(title: String, message: String, actionTitle: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default, handler: handler)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: Private methods
    
    //Sets up the reachability manager with the reachabilityHostURL that exists at the time this function is called
    fileprivate func setupReachabilityManager() {
        reachabilityManager = NetworkReachabilityManager()
        reachabilityManager.listener = { [weak self] reachabilityStatus in
            guard let strongSelf = self else { return }
            
            if strongSelf.reachabilityManager.isReachable {
                strongSelf.hideNetworkReachabilityVerificationViewController()
            } else {
                strongSelf.presentNetworkReachabilityVerificationViewController()
            }
        }
        reachabilityManager.startListening()
    }
    
    //Shows the appropriate view controller while the network connection is being established
    fileprivate func presentNetworkReachabilityVerificationViewController() {
        guard requiresNetworkReachability && isVisible() && isShowingNetworkReachabilityVerificationViewController == false else { return }
        
        isShowingNetworkReachabilityVerificationViewController = true
        
        let nrvvc = NetworkReachabilityVerificationViewController()
        networkReachabilityVerificationViewController = nrvvc
        nrvvc.modalTransitionStyle = .crossDissolve
        nrvvc.modalPresentationStyle = .overFullScreen
        present(nrvvc, animated: true, completion: nil)
    }
    
    //Hides the appropriate view controller while the network connection is being established
    fileprivate func hideNetworkReachabilityVerificationViewController() {
        guard networkReachabilityVerificationViewController != nil && isShowingNetworkReachabilityVerificationViewController else { return }
        
        networkReachabilityVerificationViewController?.dismiss(animated: true) {
            self.networkReachabilityVerificationViewController = nil
            self.isShowingNetworkReachabilityVerificationViewController = false
            self.didEstablishNetworkReachability()
        }
    }
    
    //Returns true when this view controller is visible
    fileprivate func isVisible() -> Bool {
        return isViewLoaded && view.window != nil
    }
    
    fileprivate func updateStatusBarStyle() {
        guard let _ = statusBarStyleBeforeChanging else { return }
        UIApplication.shared.setStatusBarStyle(preferredStatusBarStyle, animated: shouldAnimateStatusBarChange())
    }
    
    fileprivate func captureStatusBarStyle() {
        let currentStyle = UIApplication.shared.statusBarStyle
        if currentStyle != preferredStatusBarStyle {
            statusBarStyleBeforeChanging = currentStyle
        }
    }
    
    fileprivate func restoreStatusBarStyle() {
        guard let previousStyle = statusBarStyleBeforeChanging else { return }
        UIApplication.shared.setStatusBarStyle(previousStyle, animated: false)
    }
}
