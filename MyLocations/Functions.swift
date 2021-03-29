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
