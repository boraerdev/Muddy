//
//  ViewController.swift
//  Muddy
//
//  Created by Bora Erdem on 20.12.2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    func extractQuotedStrings(from input: String) -> [String] {
      let pattern = #"\"(.*?)\""#
      let regex = try! NSRegularExpression(pattern: pattern, options: [])
      let matches = regex.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))
      return matches.map { String(input[Range($0.range, in: input)!]) }
    }

}

