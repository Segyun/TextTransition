//
//  Text+Layout.swift
//  TextTransition
//
//  Created by Huigyun Jeong on 4/3/26.
//

import SwiftUI

extension Text.Layout {
    var flattenedRuns: some RandomAccessCollection<Text.Layout.Run> {
        self.flatMap(\.self)
    }

    var flattenedRunSlices: some RandomAccessCollection<Text.Layout.RunSlice> {
        self.flattenedRuns.flatMap(\.self)
    }
}
