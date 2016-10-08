//
//  SegmentedControl.swift
//  NXTSegmentedControl
//
//  Created by Patrick Mick on 10/8/16.
//  Copyright © 2016 Patrick Mick. All rights reserved.
//

import UIKit

final class SegmentedControl: UIControl {
    var items: [String]
    
    init(items: [String] = []) {
        self.items = items
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func titleForSegment(atIndex idx: Int) -> String? {
        return nil
    }
}
