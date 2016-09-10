//
//  MoochModalViewController.swift
//  Mooch
//
//  Created by adam on 9/10/16.
//  Copyright © 2016 cse498. All rights reserved.
//

import UIKit

//Base class modal view controller
class MoochModalViewController: MoochViewController {
    
    private var presentingViewControllerNavigationBarWasHidden = false
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        capturePresentingViewControllerNavigationBarState()
        updateNavigationBarState()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        restorePresentingViewControllerNavigationBarState()
    }
    
    //Override this function to hide the navigation bar when the modal appears
    func prefersNavigationBarHidden() -> Bool {
        return false
    }
    
    private func updateNavigationBarState() {
        if let navC = navigationController {
            navC.navigationBar.hidden = prefersNavigationBarHidden()
        }
    }
    
    private func capturePresentingViewControllerNavigationBarState() {
        if let navC = navigationController {
            presentingViewControllerNavigationBarWasHidden = navC.navigationBarHidden
        }
    }
    
    private func restorePresentingViewControllerNavigationBarState() {
        if let navC = navigationController {
            navC.navigationBar.hidden = presentingViewControllerNavigationBarWasHidden
        }
    }
}
