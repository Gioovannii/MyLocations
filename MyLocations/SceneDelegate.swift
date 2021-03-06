//
//  SceneDelegate.swift
//  MyLocations
//
//  Created by Giovanni Gaffé on 2021/2/6.
//

import UIKit
import CoreData



class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "MyLocations")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    lazy var managedObjectContext = persistentContainer.viewContext
    var window: UIWindow?
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        let tabController = window!.rootViewController as! UITabBarController
        if let tabviewControllers = tabController.viewControllers {
            let navController = tabviewControllers[0] as! UINavigationController
            let controller = navController.viewControllers.first as! CurrentLocationViewController
            controller.managedObjectContext = managedObjectContext
            listenForFatalCoreDataNotification()
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        saveContext()
    }
    
    // MARK: - Helper method
    func listenForFatalCoreDataNotification() {
        NotificationCenter.default.addObserver(forName: dataSAveWithFailedNotification, object: nil, queue: OperationQueue.main) { _ in
            let message = """
                There was a fatal error in the app and it cannot continue.
                Press OK to terminate the app. Sorry for the inconvenience.
                """
            
            let alert = UIAlertController(title: "Internal Error", message: message, preferredStyle: .alert)
            
            
            let action = UIAlertAction(title: "OK", style: .default) { _ in
                let exception = NSException(name: NSExceptionName.internalInconsistencyException, reason: "Fatal core data Error", userInfo: nil)
                exception.raise()
            }
            alert.addAction(action)
            
            let tabControler = self.window!.rootViewController
            tabControler?.present(alert, animated: true, completion: nil)
        }
    }
}

