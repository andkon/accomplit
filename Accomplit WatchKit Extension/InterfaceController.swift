//
//  InterfaceController.swift
//  Accomplit WatchKit Extension
//
//  Created by Andrew Konoff on 2018-04-16.
//  Copyright © 2018 Andrew Konoff. All rights reserved.
//

import WatchKit
import Foundation
import RealmSwift

class Accomplishment: Object, CLKComplicationDataSource {
    @objc dynamic var doneAt: Date? = nil
}

class InterfaceController: WKInterfaceController {
    private let realm = try! Realm()
    lazy private var accomplishments: Results<Accomplishment> = {
        let todayStart = Calendar.current.startOfDay(for: Date())
        let todayEnd: Date = {
            let components = DateComponents(day: 1, second: -1)
            return Calendar.current.date(byAdding: components, to: todayStart)!
        }()
        let res = self.realm.objects(Accomplishment.self).filter("doneAt BETWEEN %@", [todayStart, todayEnd])
        return res
    }()
    private var notificationToken: NotificationToken? = nil

    @IBOutlet var lastAccomplishedLabel: WKInterfaceLabel!
    @IBOutlet var countButton: WKInterfaceButton!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        self.notificationToken = self.accomplishments.observe({ [weak self] (changes: RealmCollectionChange) in
            guard let ic = self else {return}
            ic.changeCountLabel()
        })
        
        self.changeCountLabel()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        self.notificationToken?.invalidate()
    }

    @IBAction func didPressCountButton() {
        // TODO: show the circle background
        // TODO: Hide the "YOu did something x minutes ago" label
        
        let a = Accomplishment()
        a.doneAt = Date()
        
        try! self.realm.write {
            realm.add(a)
        }
    }

    func changeCountLabel() {
        let count: Int = self.accomplishments.count
        self.countButton.setTitle(String(count))
        
    }
    
    func changeLastAccomplishedLabel() {
        // figures out difference in time between now and newest Accomplishment
        // turns that into a human readable string
        // bolds it
        // adds it to other string and sets label
//        let str = "You did something swell \(count) minutes ago."
//        let bold = [NSAttributedStringKey.]
//        self.lastAccomplishedLabel.setAttributedText(<#T##attributedText: NSAttributedString?##NSAttributedString?#>)

    }
}
