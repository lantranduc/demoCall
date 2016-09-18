//
//  ViewController.swift
//  DemoCall
//
//  Created by Tran Duc Lan on 9/16/16.
//  Copyright © 2016 Tran Duc Lan. All rights reserved.
//

import UIKit
import CoreTelephony
import MBProgressHUD

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var  mainTbl     : UITableView!
    @IBOutlet weak var  btnStartCall: UIButton!
    let                 contacts    : NSMutableArray = NSMutableArray()
    var                 callCenter  : CTCallCenter?
    var                 hud         : MBProgressHUD!
    var                 isWorking   : Bool!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.initContactData()
        callCenter = CTCallCenter()
        self.handleCallCenter()
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ViewController.applicationDidBecomeActive), name: "applicationDidBecomeActive", object: nil)
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initContactData() {
        
        for index in 1...100 {
            let contact = DemoContactItem(contactName: "Lan Tran Duc \(index)", contactPhone: "+817014141995")
            contacts.addObject(contact)
        }
    }
    
    func handleCallCenter() {
        
        callCenter!.callEventHandler = { (call:CTCall!) in
            
            switch call.callState {
            case CTCallStateDialing:
                break
                
            case CTCallStateIncoming:
                break
                
            case CTCallStateConnected:
                self.callConnected()
                break
            case CTCallStateDisconnected:
                self.callDisconnected()
                break
            default:
                //Not concerned with CTCallStateDialing or CTCallStateIncoming
                break
            }
        }
    }
    
    func callConnected() {
        NSLog("CTCallStateConnected")
    }
    
    func callDisconnected () {
        NSLog("CTCallStateDisconnected")
    }
    
    func applicationDidBecomeActive(){
        
        if (isWorking != nil && isWorking == true)  {
            self.performSelector(#selector(ViewController.makeACall), withObject: nil, afterDelay: 1)
        }
    }
    
    @IBAction func upListTouchUpInside(sender: UIButton)
    {
        
    }
    
    @IBAction func downListTouchUpInside(sender: UIButton)
    {
        
    }
    
    @IBAction func btnStartCallTouchUpInside(sender: UIButton) {
        
        sender.enabled  = false
        isWorking       = true
        
        hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud!.label.text = "Start Calling"
        self.makeACall()
        

    }
    
    func makeACall(){

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            let contact = self.contacts.firstObject as! DemoContactItem
            
            
            let phoneCall = NSURL(string: "tel://\(contact.txtContactPhone)")
            let sharedApplication = UIApplication.sharedApplication() 
            if(sharedApplication.canOpenURL(phoneCall!))
            {
                self.contacts.removeObject(contact)
                self.contacts.addObject(contact)
                dispatch_async(dispatch_get_main_queue(), {
                    self.hud!.label.text = "Calling \(contact.txtContactName)"
                    self.mainTbl.reloadData()
                })
                sharedApplication.openURL(phoneCall!)
                
            }
            
            
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count;
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:DemoContactCell = tableView.dequeueReusableCellWithIdentifier("DemoContactCell", forIndexPath: indexPath) as! DemoContactCell
        let demoContact = contacts.objectAtIndex(indexPath.row) as! DemoContactItem
        
        cell.lblContactNumber.text  = demoContact.txtContactPhone
        cell.lblConactName.text     = demoContact.txtContactName
        cell.backgroundColor        = UIColor.whiteColor()
        if (demoContact.isCalled == true)
        {
            cell.backgroundColor = UIColor.grayColor()
            
        }
        
        return cell
        
        
    }

}

class DemoContactCell: UITableViewCell {
    
    @IBOutlet weak var lblConactName:       UILabel!
    @IBOutlet weak var lblContactNumber:    UILabel!
    @IBOutlet weak var btnUpList:           UIButton!
    @IBOutlet weak var btnDownList:         UIButton!
    
}

class DemoContactItem: NSObject {
    
    var txtContactName:     String!
    var txtContactPhone:    String!
    var isCalled:           Bool!
    
    init(contactName:String, contactPhone:String) {
        
        self.txtContactName  = contactName
        self.txtContactPhone = contactPhone
        self.isCalled        = false
        
    }
    
    
}

