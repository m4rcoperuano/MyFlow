//
//  GetUserLocationProtocol.swift
//  MyFlow
//
//  Created by Marco Ledesma on 7/18/15.
//  Copyright (c) 2015 Marco Ledesma. All rights reserved.
//

import Foundation

protocol GetUserLocationProtocol {
    func execute(#completeBlock: ((GetWeatherResult!) -> Void)!);
}
