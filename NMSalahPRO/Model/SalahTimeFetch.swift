//
//  SalahTimeFetch.swift
//  NMSalahPRO
//
//  Created by Navid on 4/24/20.
//  Copyright © 2020 UnitedStar. All rights reserved.
//

import Foundation

public class SalahTimeFetch {
    
    func refreshSalahTime(){
        
        let session = URLSession.shared
        
        let zipcode = "08876"
        let method = "4"
        let juristic = "1"
        let country = "US"
        let urlString = "https://www.islamicfinder.us/index.php/api/prayer_times?country=\(country)&zipcode=\(zipcode)&method=\(method)&juristic=\(juristic)"
        let apiURL = URL(string: urlString)
        let task = session.dataTask(with: apiURL!, completionHandler: callBackKoro)
        task.resume()
    }
    
    //    INTERNAL FUNCTIONS
    
    private func callBackKoro(data:Data?, response:URLResponse?, error:Error?) -> Void {
        if data != nil {
            
            let json = try? JSONSerialization.jsonObject(with: data!, options: [])
            
            if let dictionary = json as? [String: Any] {
                
                if let number = dictionary["results"] as? [String: String] {
                    
                    for (key, value) in number {
                        
//                        if(key == "Fajr") { self.fajrTIME  = value.filter({$0 != "%"}) }
//                        if(key == "Asr") { self.assrTIME  = value.filter({$0 != "%"}) }
//                        if(key == "Dhuhr") { self.dhuhrTIME  = value.filter({$0 != "%"}) }
//                        if(key == "Maghrib") { self.maghribTIME  = value.filter({$0 != "%"}) }
//                        if(key == "Isha") { self.ishaTIME  = value.filter({$0 != "%"}) }
                    }
                    
//                    delegateFunc()
                    print("DONE!")
                } else { print("no results") }
                
            } else { print("NO DATA") }
            
        } else {
            print("FAILED!")
        }
    }
    
}
