//
//  AppDelegate.swift
//  Universal
//
//  Created by Mark on 29/09/2019.
//  Copyright © 2019 Sherdle. All rights reserved.
//

import Foundation
import OneSignal
import SafariServices
import AppTrackingTransparency
import AdSupport

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GADInterstitialDelegate {

    //START OF CONFIGURATION

    static let CONFIG = ""

    /**
     * Layout options
     */
    static let APP_THEME_LIGHT = true
    static let APP_THEME_COLOR = UIColor(red: 0.20, green: 0.60, blue: 0.86, alpha: 1.0)

    static let GRADIENT_ONE = UIColor(red: 0.11, green: 0.38, blue: 0.94, alpha: 1.0)
    static let GRADIENT_TWO = UIColor(red: 0.11, green: 0.73, blue: 0.85, alpha: 1.0)
    static let APP_DRAWER_HEADER = true
    static let MENU_TEXT_COLOR = UIColor.white
    static let MENU_TEXT_COLOR_SECTION = UIColor.lightText
    
    static let WP_ATTACHMENTS_BUTTON = false

    /**
     * About / Texts
     **/
    static let NO_CONNECTION_TEXT = "We weren't able to connect to the server. Make sure you have a working internet connection."
    static let ABOUT_TEXT = "Obrigado por baixar nosso app! \n\nISe precisar de desenvolvimento para a sua empresa toque no botao abaixo"
    static let ABOUT_URL = "https://msanders.carrd.co"
    static let PRIVACY_POLICY_URL = "https://msanders.carrd.co/#politicadeprivacidade"
    //Clearing both your About Text and About URL will hide the about button

    /**
     * Monetization
     **/
    static let INTERSTITIAL_INTERVAL = 5
    static let ADMOB_INTERSTITIAL_ID = ""
    static let BANNER_ADS_ON = false
    static let ADMOB_UNIT_ID = ""
    static let ADMOB_APP_ID = ""
    static let INTERSTITIALS_FOR_WEBVIEW = true

    static let IN_APP_PRODUCT = ""

    /**
     * API Keys
     **/
    static let ONESIGNAL_APP_ID = ""

    static let MAPS_API_KEY = "AIzaSyAQ5QmpPsm9WNPV2dYryXDVu62e7hrh7aM"

    static let VIMEO_API = "1d66b35d141e481dc3a7df7c04f0982d"

    static let TWITTER_API = "eSbRR2No25QLa357l7HQvcaFw"
    static let TWITTER_API_SECRET = "8Ip7VEy4B6MUweMNwnzaJpNP0jywbnqLfMkgAkdudvSgxZayBn"
    static let TWITTER_TOKEN = "402725885-WGqZXqZVWx4F2v04RpKNnH2nyaxvGtrpgIRh4jq8"
    static let TWITTER_TOKEN_SECRET = "e4VOQX8hIAbIe8dqbkDtZF5NH5KaMFvdV6WiIP2KrCxxQ"

    static let PINTEREST_ACCESS_TOKEN = "Ao-BuwwQmtzuiQj1An8i6bQDZR0iFZeWot5HagtDi_0seMAr2AVyQDAAAFDyRNWIp8RgPa4AAAAA"

    static let SOUNDCLOUD_CLIENT = "b6699250e974837de717cf1e0ca5ca4a"
    static let SOUNDCLOUD_CLIENT_SECRET = "ffd51b7af360c8d1e650801e83fff2a8"

    static let FLICKR_API = "c1f63725521d955d0ceed11a7430f0b8"
    static let TUMBLR_API = "XddydOnUISsEsmj0iZNFUv0KMd42G89e2x2EqXbw2q1ymLIE6s"

    /**
     * WooCommerce
     **/
    static let WOOCOMMERCE_HOST = "https://sherdle.com/apphosting/universal/woocommerce/"
    static let WOOCOMMERCE_KEY = "ck_90fc4193a92001a665ff32ab3afbef060482fd01"
    static let WOOCOMMERCE_SECRET = "cs_3ba341ee05260711a0aa2ff6aa6076743de0991d"

    /**
     * WebView & Url opening
     */
    static let OPEN_IN_BROWSER = false
    static let BROWSER_IS_SAFARICONTROLLER = false;
    
    static let OPEN_BROWSER: [String] = []
    static let openTargetBlankSafari = false
    static let WEBVIEW_HIDE_NAVIGATION = false
    
    /**
     * Navigationbar
     */
    static let DISABLED_NAVIGATIONBAR = false
    static let HIDING_NAVIGATIONBAR = true
    static let APP_BAR_SHADOW = true

    //END OF CONFIGURATION
    
    var window: UIWindow?
    var interstitialCount:Int = 0
    var interstitialAd : GADInterstitial?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        GMSServices.provideAPIKey(AppDelegate.MAPS_API_KEY)

        TvViewController.initPlayer()

        // Ads
        if AppDelegate.BANNER_ADS_ON && !AppDelegate.hasPurchased() {
            let revealController = self.window?.rootViewController as! SWRevealViewController

            GADMobileAds.sharedInstance().start(completionHandler: nil)
            CJPAdMobHelper.sharedInstance().adMobUnitID = AppDelegate.ADMOB_UNIT_ID
            CJPAdMobHelper.sharedInstance().start(with: revealController)
            //UIApplication.sharedApplication.delegate?.window.rootViewController = CJPAdMobHelper.sharedInstance()
            
            // Request test ads on devices you specify. Your test device ID is printed to the console when
            // an ad request is made.
            GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ (kGADSimulatorID as! String), "YourTestDevice" ]
            
            self.window!.rootViewController = CJPAdMobHelper.sharedInstance()

            revealController.frontViewController.viewDidLoad()
            
        }

        //In App purchases
        if AppDelegate.IN_APP_PRODUCT.count > 0 {
            WBInAppHelper.setProductsList([AppDelegate.IN_APP_PRODUCT])
        }

        // OneSignal/Notifications
        if AppDelegate.ONESIGNAL_APP_ID.count > 0 {
            //self.oneSignal = OneSignal(launchOptions:launchOptions, appId:ONESIGNAL_APP_ID)
            
            let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]

            OneSignal.initWithLaunchOptions(launchOptions,
                                            appId: AppDelegate.ONESIGNAL_APP_ID,
            handleNotificationAction: nil,
            settings: onesignalInitSettings)

            OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;

            OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
            })
        }

        return true
    }
    
    private func application(application:UIApplication!, didRegisterForRemoteNotificationsWithDeviceToken deviceToken:NSData!) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print(token)
    }

    private func application(application:UIApplication!, didFailToRegisterForRemoteNotificationsWithError error:NSError!) {
        NSLog("Failed to get token, error: %= ", error)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if AppDelegate.BANNER_ADS_ON && !AppDelegate.hasPurchased() {
            
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                    // Tracking authorization completed. Start loading ads here.
                    // loadAd()
                })
            } else {
                // Fallback on earlier versions
            }
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //--- ObjC
    
    @objc
    static func alwaysLightNavigationBar() -> Bool {
        return !AppDelegate.APP_THEME_LIGHT && AppDelegate.DISABLED_NAVIGATIONBAR;
    }
    
    //--- Utility for opening urls
    
    class func openUrl(url:String!, withNavigationController navController:UINavigationController!) {
        if OPEN_IN_BROWSER || (navController == nil) {
            openInBrowser(url: url, withNavigationController: navController)
        } else {
            //Make the header/navbar solid
            if (navController is TabNavigationController) {
                let nc = navController as! TabNavigationController
                nc.enableTransparencyFunctions(enable: false)
            }

            let storyboard:UIStoryboard! = UIStoryboard(name: "Main", bundle:nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewSwiftController
            vc.params = [url!]
            navController.pushViewController(vc, animated:true)
        }
    }
    
    class func openInBrowser(url:String!, withNavigationController navController:UINavigationController!) {
        guard let urlV = URL(string: url) else { return }

        if (!BROWSER_IS_SAFARICONTROLLER || (navController == nil)) {
            UIApplication.shared.open(urlV)
        } else {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = false;

            let vc = SFSafariViewController(url: urlV, configuration: config)
            navController.present(vc, animated: true)
        }
    }
    
    //-- Interstitials

    func reloadInterstitialAd() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: AppDelegate.ADMOB_INTERSTITIAL_ID)
        interstitial.delegate = self
        let request = GADRequest()
        //request.testDevices = [kGADSimulatorID]
        interstitial.load(request)
        return interstitial
    }
    
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("\(ad) did fail to receive ad with error \(error)")
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        self.interstitialAd = reloadInterstitialAd()
    }
    
    func showInterstitial(controller: UIViewController) {
        if shouldShowInterstitial() && self.interstitialAd?.isReady ?? false {
            self.interstitialAd?.present(fromRootViewController: self.window!.rootViewController!)
        }
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        self.interstitialAd = ad
    }
    
    func interstitialsEnabled() -> Bool {
        if AppDelegate.ADMOB_INTERSTITIAL_ID.count == 0 {return false}
        if AppDelegate.INTERSTITIAL_INTERVAL == 0 {return false}
        if AppDelegate.hasPurchased() {return false}
        
        return true;
    }

    func shouldShowInterstitial() -> Bool {
        if !interstitialsEnabled() { return false }
        
        if self.interstitialAd == nil { self.interstitialAd = reloadInterstitialAd() }
        
        var shouldShowInterstitial = false
        if interstitialCount == AppDelegate.INTERSTITIAL_INTERVAL {
            shouldShowInterstitial = true
            interstitialCount = 0
        }

        interstitialCount += 1
        return shouldShowInterstitial
    }

    class func hasPurchased() -> Bool {
        if IN_APP_PRODUCT.count == 0 {return false}

        return WBInAppHelper.isProductPaid(IN_APP_PRODUCT)
    }


}
