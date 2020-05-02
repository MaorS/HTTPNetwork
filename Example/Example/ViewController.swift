//
//  ViewController.swift
//  Example
//
//  Created by Maor Shamsian on 02/05/2020.
//  Copyright © 2020 Maor Shamsian. All rights reserved.
//

import UIKit
import HTTPNetworkAPI

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    static let url = URL(string: "http://www.mocky.io/v2/5ead49d82f00006600198712")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let httpNetwork = HTTPNetwork()
        
        guard let request = httpNetwork
            .makeRequest()
            .set(url: ViewController.url)
            .set(method: .get)
            .build() else {
                return
        }
        
        httpNetwork.execute(request: request,
                            onSuccess: { [weak self] data in
                                self?.present(message: data)
        }) { [weak self] error in
            self?.present(message: (error as NSError).localizedDescription)
        }
    }
    
    private func present(message: String?) {
        DispatchQueue.main.async {
            self.label.text = message
        }
    }
    
}

