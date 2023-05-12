import Flutter
import UIKit

public class SwiftBarcodeFinderPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "popcode.com.br/barcode_finder", binaryMessenger: registrar.messenger())
        let instance = SwiftBarcodeFinderPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if(call.method == "scan_pdf") {
            guard let args = call.arguments else {
                result(FlutterError(code: "no-arguments", message: "No arguments provided", details: nil))
                return
            }
            if let myArgs = args as? [String: Any]{
                let filePath = myArgs["filePath"] as! String
                let barcodeFormats = myArgs["barcodeFormats"] as? [String]
                let url = URL(fileURLWithPath: filePath)
                let scanner = BarcodeScanner()
                
                DispatchQueue.global().async {
                    let pdfImages = url.pdfPagesToImages()
                    DispatchQueue.main.async {
                        if pdfImages == nil{
                            result(FlutterError(code: "not-found" , message: "No barcode found on the file", details: nil))
                            return
                        }
                        let barcodesToFilter = BarcodeFormatType.createBarcodeFormatTypeFromStrings(strings: barcodeFormats!)
                        var resultArr: [String] = []
                        for uiImage in pdfImages ?? [UIImage](){
                            resultArr.append(contentsOf: scanner.tryFindBarcodeFrom(uiImage: uiImage, barcodesToFilter: barcodesToFilter))
                        }
                        
                        if resultArr.count == 0 {
                            result(FlutterError(code: "not-found" , message: "No barcode found on the file", details: nil))
                        } else {
                            result(resultArr)
                        }
                        return
                    }
                }
                
                
            } else {
                result(FlutterError(code: "no-arguments", message: "No arguments provided", details: nil))
                return
            }
        }
        if(call.method == "scan_image") {
            guard let args = call.arguments else {
                result(FlutterMethodNotImplemented)
                return
            }
            if let myArgs = args as? [String: Any]{
                let filePath = myArgs["filePath"] as! String
                let barcodeFormats = myArgs["barcodeFormats"] as? [String]
                let url = URL(fileURLWithPath: filePath)
                let scanner = BarcodeScanner()
                let uiImage = UIImage.init(contentsOfFile: url.path)
                if uiImage == nil{
                    result(FlutterError(code: "not-found" , message: "No barcode found on the file", details: nil))
                    return
                }
                var resultArr: [String] = []
                let barcodesToFilter = BarcodeFormatType.createBarcodeFormatTypeFromStrings(strings: barcodeFormats!)
                    resultArr.append(contentsOf: scanner.tryFindBarcodeFrom(uiImage: uiImage!, barcodesToFilter: barcodesToFilter))
                if resultArr.count == 0 {
                    result(FlutterError(code: "not-found" , message: "No barcode found on the file", details: nil))
                } else {
                    result(resultArr)
                }
                return
            } else {
                result(FlutterError(code: "no-arguments", message: "No arguments provided", details: nil))

            }
        }
    }
}
