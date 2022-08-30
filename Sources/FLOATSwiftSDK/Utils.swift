//
//  File.swift
//  
//
//  Created by BoiseITGuru on 8/30/22.
//

import Foundation

func formatDate(timestamp: Double) -> String {
    let date = Date(timeIntervalSince1970: timestamp)
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = DateFormatter.Style.short
    dateFormatter.timeZone = .current
    return dateFormatter.string(from: date)
}
