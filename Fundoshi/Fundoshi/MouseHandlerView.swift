//
//  MouseHandlerView.swift
//  Fundoshi
//
//  Created by ookamitai on 8/6/24.
//

import Foundation
import SwiftUI

class MouseHandlerView: NSView {
    var onRightMouseDown: (() -> Void)? = nil
    var onMouseDown: (() -> Void)? = nil

    override func rightMouseDown(with event: NSEvent) {
        if let onRightMouseDown {
            onRightMouseDown()
        } else {
            super.rightMouseDown(with: event)
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        if let onMouseDown {
            onMouseDown()
        } else {
            super.mouseDown(with: event)
        }
    }
}

