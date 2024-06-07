//
//  Video.swift
//  CYTGM
//
//  Created by student on 6/7/24.
//
import SwiftData
import Foundation
struct Video: Codable {
    var id: Int
    var title: String
    var description: String
    var tags: [Tag]
    var dateAdded: Date
    var link: String
}
extension Date {
    init(_ dateString:String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        let date = dateStringFormatter.date(from: dateString)!
        self.init(timeInterval:0, since:date)
    }
}
