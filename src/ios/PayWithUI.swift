//
//  Created by Efe Ariaroo on 10/05/2016.
//  Copyright © 2016 Interswitch Limited. All rights reserved.

import UIKit
import PaymentSDK


public class PayWithUI {
    private static var cdvPlugin : PaymentPlugin?
    private static var currentVc : UIViewController?
    private static var isSdkVcShownForWallet  = false
    private static var window : UIWindow?
    
    
    class func payWithCard(cdvPlugin: PaymentPlugin, command: CDVInvokedUrlCommand,
                           theCustomerId: String, theCurrency:String, theDescription:String, theAmount:String) {
        PayWithUI.cdvPlugin = cdvPlugin
        
        let payWithCard = PayWithCard(clientId: cdvPlugin.clientId, clientSecret: cdvPlugin.clientSecret,
                                      customerId: theCustomerId, description: theDescription,
                                      amount:theAmount, currency:theCurrency)
        
        let vc = payWithCard.start({(purchaseResponse: PurchaseResponse?, error: NSError?) in
            guard error == nil else {
                let errMsg = (error?.localizedDescription)!
                
                Utils.sendErrorBackToJavascript(cdvPlugin, cdvCommand: command, errMsg: errMsg)
                cdvPlugin.viewController?.dismissViewControllerAnimated(true, completion: nil)
                return
            }
            guard let response = purchaseResponse else {
                let failureMsg = (error?.localizedFailureReason)!
                
                Utils.sendErrorBackToJavascript(cdvPlugin, cdvCommand: command, errMsg: failureMsg)
                cdvPlugin.viewController?.dismissViewControllerAnimated(true, completion: nil)
                return
            }
            
            //Handling success
            Utils.sendSuccessBackToJavascript(cdvPlugin, cdvCommand: command, successMsg: Utils.getJsonOfPurchaseResponse(response))
            cdvPlugin.viewController?.dismissViewControllerAnimated(true, completion: nil)
        })
        
        let screenTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        vc.view.addGestureRecognizer(screenTap)
        
        let navController = UINavigationController(rootViewController: vc)
        //addBackNavigationMenuItem(navController)
        
        cdvPlugin.viewController?.presentViewController(navController, animated: true, completion: nil)
        currentVc = navController
        isSdkVcShownForWallet = false
    }
    
    class func payWithWallet(cdvPlugin: PaymentPlugin, command: CDVInvokedUrlCommand,
                             theCustomerId: String, theCurrency:String, theDescription:String, theAmount:String) {
        PayWithUI.cdvPlugin = cdvPlugin
        
        let payWithWallet = PayWithWallet(clientId: cdvPlugin.clientId, clientSecret: cdvPlugin.clientSecret,
                                          customerId: theCustomerId, description: theDescription,
                                          amount: theAmount, currency: theCurrency)
        let vc = payWithWallet.start({(purchaseResponse: PurchaseResponse?, error: NSError?) in
            guard error == nil else {
                let errMsg = (error?.localizedDescription)!
                
                Utils.sendErrorBackToJavascript(cdvPlugin, cdvCommand: command, errMsg: errMsg)
                window?.rootViewController = cdvPlugin.viewController!
                window?.makeKeyAndVisible()
                return
            }
            
            guard let response = purchaseResponse else {
                let failureMsg = (error?.localizedFailureReason)!
                
                Utils.sendErrorBackToJavascript(cdvPlugin, cdvCommand: command, errMsg: failureMsg)
                window?.rootViewController = cdvPlugin.viewController!
                window?.makeKeyAndVisible()
                return
            }
            //Handling success
            Utils.sendSuccessBackToJavascript(cdvPlugin, cdvCommand: command, successMsg: Utils.getJsonOfPurchaseResponse(response))
            window?.rootViewController = cdvPlugin.viewController!
            window?.makeKeyAndVisible()
        })
        
        let screenTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        vc.view.addGestureRecognizer(screenTap)
        
        let navController = UINavigationController(rootViewController: vc)
        //addBackNavigationMenuItem(navController)
        
        if(window == nil) {
            if let app = UIApplication.sharedApplication().delegate as? CDVAppDelegate, let keyWindow = app.window {
                window = keyWindow
            }
        }
        window!.rootViewController = navController
        window!.makeKeyAndVisible()
        
        currentVc = navController
        isSdkVcShownForWallet = true
    }
    
    class func payWithToken(cdvPlugin: PaymentPlugin, command: CDVInvokedUrlCommand, theCustomerId: String, paymentDescription:String,
                            theToken:String, theAmount:String, theCurrency:String, theExpiryDate:String, theCardType:String, thePanLast4Digits:String){
        PayWithUI.cdvPlugin = cdvPlugin
        
        let payWithToken = PayWithToken(clientId: cdvPlugin.clientId, clientSecret: cdvPlugin.clientSecret,
                                        customerId: theCustomerId, description: paymentDescription,
                                        amount:theAmount, token: theToken, currency:theCurrency,
                                        expiryDate: theExpiryDate, cardType: theCardType, last4Digits: thePanLast4Digits)
        
        let vc = payWithToken.start({(purchaseResponse: PurchaseResponse?, error: NSError?) in
            guard error == nil else {
                let errMsg = (error?.localizedDescription)!
                
                Utils.sendErrorBackToJavascript(cdvPlugin, cdvCommand: command, errMsg: errMsg)
                cdvPlugin.viewController?.dismissViewControllerAnimated(true, completion: nil)
                return
            }
            guard let response = purchaseResponse else {
                let failureMsg = (error?.localizedFailureReason)!
                
                Utils.sendErrorBackToJavascript(cdvPlugin, cdvCommand: command, errMsg: failureMsg)
                cdvPlugin.viewController?.dismissViewControllerAnimated(true, completion: nil)
                return
            }
            
            //Handling success
            Utils.sendSuccessBackToJavascript(cdvPlugin, cdvCommand: command, successMsg: Utils.getJsonOfPurchaseResponse(response))
            cdvPlugin.viewController?.dismissViewControllerAnimated(true, completion: nil)
        })
        
        let screenTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        vc.view.addGestureRecognizer(screenTap)
        
        let navController = UINavigationController(rootViewController: vc)
        //addBackNavigationMenuItem(navController)
        
        cdvPlugin.viewController?.presentViewController(navController, animated: true, completion: nil)
        currentVc = navController
        isSdkVcShownForWallet = false
    }
    
    class func validatePaymentCard(cdvPlugin: PaymentPlugin, command: CDVInvokedUrlCommand, theCustomerId: String) {
        PayWithUI.cdvPlugin = cdvPlugin
        
        let validateCard = ValidateCard(clientId: cdvPlugin.clientId, clientSecret: cdvPlugin.clientSecret, customerId: theCustomerId)
        
        let vc = validateCard.start({(validateCardResponse: ValidateCardResponse?, error: NSError?) in
            guard error == nil else {
                let errMsg = (error?.localizedDescription)!
                
                Utils.sendErrorBackToJavascript(cdvPlugin, cdvCommand: command, errMsg: errMsg)
                cdvPlugin.viewController?.dismissViewControllerAnimated(true, completion: nil)
                return
            }
            
            guard let response = validateCardResponse else {
                let failureMsg = (error?.localizedFailureReason)!
                
                Utils.sendErrorBackToJavascript(cdvPlugin, cdvCommand: command, errMsg: failureMsg)
                cdvPlugin.viewController?.dismissViewControllerAnimated(true, completion: nil)
                return
            }
            //Handling success
            Utils.sendSuccessBackToJavascript(cdvPlugin, cdvCommand: command, successMsg: Utils.getJsonOfPurchaseResponse(response))
            cdvPlugin.viewController?.dismissViewControllerAnimated(true, completion: nil)
        })
        
        let screenTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        vc.view.addGestureRecognizer(screenTap)
        
        let navController = UINavigationController(rootViewController: vc)
        //addBackNavigationMenuItem(navController)
        
        cdvPlugin.viewController?.presentViewController(navController, animated: true, completion: nil)
        currentVc = navController
        isSdkVcShownForWallet = false
    }
    
    
    @objc class func dismissKeyboard() {
        currentVc!.view.endEditing(true)
    }
    
    class func addBackNavigationMenuItem(sdkVc: UIViewController) {
        let view : UIView = sdkVc.view
        
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y:30, width: 3 * (sdkVc.view.frame.size.width), height: 25))
        navigationBar.backgroundColor = UIColor.whiteColor()
        
        let navigationItem = UINavigationItem()
        //navigationItem.title = "Pay"
        
        let leftButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PayWithUI.backAction))
        
        navigationItem.leftBarButtonItem = leftButton
        navigationBar.items = [navigationItem]
        
        view.addSubview(navigationBar)
    }
    
    @objc class func backAction() {
        if(isSdkVcShownForWallet) {
            window?.rootViewController = cdvPlugin?.viewController!
            window?.makeKeyAndVisible()
        } else {
            currentVc?.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
