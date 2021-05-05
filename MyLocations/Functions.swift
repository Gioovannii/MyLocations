//
//  Functions.swift
//  MyLocations
//
//  Created by Giovanni Gaffé on 2021/3/28.
//

import Foundation

func afterDelay(_ seconds: Double, run: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: run)
}

let applicationDocumentsDirectory: URL = {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}()

let dataSAveWithFailedNotification = Notification.Name(rawValue: "DataSaveFailedNotification")



