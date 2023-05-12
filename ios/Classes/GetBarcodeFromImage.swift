//
//  GetBarcodeFromImage.swift
//  barcode_finder
//
//  Created by Rafael Aquila on 25/12/20.
//

import Foundation

func getBarcodeFromImage(uiImage: UIImage, barcodesToFilter: [BarcodeFormatType] = [BarcodeFormatType.any]) -> [String] {
    var array: [String] = []
    let scanners = [scanUsingZxing, scanUsingZBar]
    for scanner in scanners{
        array.append(contentsOf: scanner(uiImage, barcodesToFilter))
    }
    return array
}


private func scanUsingZxing(_ image: UIImage, barcodesToFilter: [BarcodeFormatType]) ->[String]{
    return zxingScanImage(image, barcodesToFilter: barcodesToFilter)
}

private func scanUsingZBar(_ image: UIImage, barcodesToFilter: [BarcodeFormatType]) -> [String] {
    return zbarScanImage(image, barcodesToFilter: barcodesToFilter)
}

