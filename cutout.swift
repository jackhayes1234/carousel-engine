// Cut the main subject out of an image with macOS Vision (macOS 14+). Usage: cutout <in> <out.png>
import CoreImage
import Foundation
import Vision

let args = CommandLine.arguments
guard args.count == 3, let image = CIImage(contentsOf: URL(fileURLWithPath: args[1])) else {
    FileHandle.standardError.write("usage: cutout <in> <out.png>\n".data(using: .utf8)!)
    exit(1)
}
let request = VNGenerateForegroundInstanceMaskRequest()
let handler = VNImageRequestHandler(ciImage: image)
do {
    try handler.perform([request])
    guard let result = request.results?.first else {
        FileHandle.standardError.write("no subject found\n".data(using: .utf8)!)
        exit(2)
    }
    let buffer = try result.generateMaskedImage(
        ofInstances: result.allInstances, from: handler, croppedToInstancesExtent: true)
    try CIContext().writePNGRepresentation(
        of: CIImage(cvPixelBuffer: buffer), to: URL(fileURLWithPath: args[2]),
        format: .RGBA8, colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!)
} catch {
    FileHandle.standardError.write("\(error)\n".data(using: .utf8)!)
    exit(3)
}
