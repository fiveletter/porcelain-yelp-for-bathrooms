//
//  NavigationReplacementSegue.swift
//  YelpForBathrooms
//
//  Created by Mitchell Waldman on 11/22/15.
//  Copyright © 2015 Five Letter. All rights reserved.
//

import UIKit

class NavigationReplacementSegue: UIStoryboardSegue {
    override func perform() {
        let sourceViewController = self.sourceViewController;
        let destinationController = self.destinationViewController;
        let navigationController = sourceViewController.navigationController;
        // Pop to root view controller (not animated) before pushing
        navigationController?.popToRootViewControllerAnimated(false);
        navigationController?.pushViewController(destinationController, animated: true);
    }
}
