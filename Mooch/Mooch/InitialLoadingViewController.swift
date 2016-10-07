//
//  InitialLoadingViewController.swift
//  Mooch
//
//  Created by adam on 9/10/16.
//  Copyright © 2016 cse498. All rights reserved.
//

import UIKit

class InitialLoadingViewController: MoochModalViewController {

    // MARK: Public variables
    
    // MARK: Private variables
    
    // MARK: Actions
    
    // MARK: Public methods
    
    override func setup() {
        super.setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getDataInitiallyNeededFromAPI()
    }
    
    override func prefersNavigationBarHidden() -> Bool {
        return true
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func shouldAnimateStatusBarChange() -> Bool {
        return false
    }
    
    func onFinishedLoading() {
        performCrossFadeViewControllerPop()
    }
    
    
    // MARK: Private methods

    private func getDataInitiallyNeededFromAPI() {
        MoochAPI.GETListingCategories() { listingCategories, error in
            if let listingCategories = listingCategories {
                ListingCategoryManager.sharedInstance.update(withListingCategories: listingCategories)
                self.onFinishedLoading()
            } else {
                self.presentCouldNotDownloadInitialDataAlert()
            }
        }
    }
    
    private func presentCouldNotDownloadInitialDataAlert() {
        presentSingleActionAlert(title: "Problem Connecting to Mooch", message: "We were unable to download the data needed to launch", actionTitle: "Try Again") { action in
            self.getDataInitiallyNeededFromAPI()
        }
    }
    
    fileprivate func performCrossFadeViewControllerPop() {
        guard let navC = navigationController else { return }
        
        // Setup cross fade transition for popping view controller
        let transtion = CATransition()
        transtion.duration = 0.3
        transtion.type = kCATransitionFade
        navC.view.layer.add(transtion, forKey: kCATransition)
        navC.setNavigationBarHidden(false, animated: false)
        navC.popViewController(animated: false)
    }
}
