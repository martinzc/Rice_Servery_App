//
//  serverConnection.swift
//  ServeryApp
//
//  Created by Martin Zhou on 6/5/16.
//  Copyright © 2016 Martin Zhou. All rights reserved.
//

import Foundation

func connectAndParse() -> [String: [String]] {
    //create a socket connect to Amazon server and port at 7890
    let client:TCPClient = TCPClient(addr: "52.38.20.26", port: 7890)
    // connect with timeout
    let (success, errmsg) = client.connect(timeout: 10)
    if success {
        // send client data to server
        let (success, errmsg) = client.send(str:"iOS\n" )
        if success {
            print("Connected to  server")
            // read data from server
            let data: [UInt8]  = client.read(1024 * 10)!
            // convert the data read to string
            let str = String(bytes: data, encoding: NSUTF8StringEncoding)
            // parse string into three different strings [type, date, menu]
            let sep_str = str?.componentsSeparatedByString("\n\n\n")
            // get menu from parsed string
            let menu = sep_str!.last
            // change menu to NSdata so that we can parse json
            let data_str = menu!.dataUsingEncoding(NSUTF8StringEncoding)
            var menu_dict = [String: [String]]()
            
            do {
                // parse json
                let json = try NSJSONSerialization.JSONObjectWithData(data_str!, options: .AllowFragments)
                // loop through the json and create a dictionary for it
                if let statusesArray = json as? NSDictionary{
                    for (servery, servery_menu) in statusesArray {
                        menu_dict[servery as! String] = servery_menu as? [String]
                    }
                }
                return menu_dict
                //                    print(menu_dict)
            } catch {
                print("error serializing JSON: \(error)")
            }
        }else {
            print(errmsg)
        }
    } else {
        print(errmsg)
    }
    return [:]
}
