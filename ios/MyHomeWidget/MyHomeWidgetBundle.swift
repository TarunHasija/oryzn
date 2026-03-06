//
//  MyHomeWidgetBundle.swift
//  MyHomeWidget
//
//  Created by Tarun hasija on 17/02/26.
//

import WidgetKit
import SwiftUI

@main
struct MyHomeWidgetBundle: WidgetBundle {
    var body: some Widget {
        MyHomeWidget()
        MyHomeWidgetControl()
        MyHomeWidgetLiveActivity()
    }
}
