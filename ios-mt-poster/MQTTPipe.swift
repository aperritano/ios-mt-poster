//
//  MQTTPipe.swift
//  
//
//  Created by Anthony Perritano on 6/11/14.
//
//


import Foundation
import UIKit
import MQTTKit

let _mqttSharedInstance = MQTTPipe()

class MQTTPipe {
    
    let kMQTTServerHost = "iot.eclipse.org"
    let kInitTopic = "IAMPOSTER"
    var topics = ["IAMPOSTER"]
    var mqttInstance: MQTTClient
    
    class var sharedInstance : MQTTPipe {
        return _mqttSharedInstance
    }
    
    init() {
        var clientID = UIDevice.currentDevice().identifierForVendor.UUIDString
        
        mqttInstance = MQTTClient(clientId: clientID)
        
        mqttInstance.connectToHost(kMQTTServerHost, completionHandler: { (code: MQTTConnectionReturnCode) -> Void in
            
//            if code.value == ConnectionAccepted {
//                self.mqttInstance.publishString("Connectioned \(clientID)", toTopic: self.topics[0], withQos: AtMostOnce, retain: true, completionHandler: { mid in
//                    
//                    println("message has been delivered");
//                    })
//                println("Connection Accepted")
//            } else {
                println("MQTT CONNECTED return code \(code.value)")
//            }
            
        })
    }
    
    func subscribeTopic(topic: String) {
        
        mqttInstance.subscribe(topic, withCompletionHandler: { grantedQos in
            println("subscribed to topic \(topic)");
            
        })
        
    }
    
    func sendMessage(message: String) {
        
        for topic in topics {
            mqttInstance.publishString(message, toTopic: topic, withQos: AtMostOnce, retain: false, completionHandler: { mid in
                
                println("message has been delivered");
                })
        }
        
       
    }
    
}