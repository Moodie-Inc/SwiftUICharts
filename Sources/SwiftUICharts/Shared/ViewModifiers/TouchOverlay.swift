//
//  TouchOverlay.swift
//  LineChart
//
//  Created by Will Dale on 29/12/2020.
//

import SwiftUI

#if !os(tvOS)
/**
 Finds the nearest data point and displays the relevent information.
 */
internal struct TouchOverlay<T>: ViewModifier where T: CTChartData {

    @ObservedObject var chartData: T
        
    internal init(chartData         : T,
                  specifier         : String
    ) {
        self.chartData = chartData
        self.chartData.infoView.touchSpecifier = specifier
    }
    
    internal func body(content: Content) -> some View {
        Group {
            if chartData.isGreaterThanTwo() {
                GeometryReader { geo in
                    ZStack {
                        content
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { (value) in
                                        
                                        chartData.setTouchInteraction(touchLocation: value.location,
                                                                      chartSize: geo)

                                    }
                                    .onEnded { _ in
                                        chartData.infoView.isTouchCurrent   = false
                                        chartData.infoView.touchOverlayInfo = []
                                    }
                            )
                        if chartData.infoView.isTouchCurrent {
                            chartData.getTouchInteraction(touchLocation: chartData.infoView.touchLocation,
                                                       chartSize: geo)
                        }
                    }
                }
            } else { content }
        }
    }
}
#endif

extension View {
    #if !os(tvOS)
    /**
     Adds touch interaction with the chart.
     
     Adds an overlay to detect touch and display the relivent information from the nearest data point.
     
     - Requires:
     If  LineChartStyle --> infoBoxPlacement is set to .header
     then `.headerBox` is required.
     
     If  LineChartStyle --> infoBoxPlacement is set to .fixed or . floating
     then `.infoBox` is required.
     
     - Attention:
     Unavailable in tvOS
     
     - Parameters:
        - chartData: Chart data model.
        - specifier: Decimal precision for labels.
     - Returns: A  new view containing the chart with a touch overlay.
     */
    public func touchOverlay<T: CTChartData>(chartData: T,
                                           specifier: String = "%.0f"
    ) -> some View {
        self.modifier(TouchOverlay(chartData: chartData,
                                   specifier: specifier))
    }
    #elseif os(tvOS)
    /**
     Adds touch interaction with the chart.
     
     - Attention:
     Unavailable in tvOS
     */
    public func touchOverlay<T: CTChartData>(chartData: T,
                                           specifier: String = "%.0f"
    ) -> some View {
        self.modifier(EmptyModifier())
    }
    #endif
}
