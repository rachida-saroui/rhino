//
//  Copyright 2022 Picovoice Inc.
//  You may not use this file except in compliance with the license. A copy of the license is located in the "LICENSE"
//  file accompanying this source.
//  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on
//  an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the
//  specific language governing permissions and limitations under the License.
//

import AVFoundation
import XCTest

import Rhino

class RhinoAppTestUITests: XCTestCase {
    let accessKey: String = "{TESTING_ACCESS_KEY_HERE}"
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    override func tearDown() {
       super.tearDown()
    }
    
    func testInitSuccessSimple() throws {
        let bundle = Bundle(for: type(of: self))
        let contextPath = bundle.path(forResource: "coffee_maker_ios", ofType: "rhn")!
        let r = try Rhino.init(
            accessKey: accessKey,
            contextPath: contextPath)
        
        XCTAssert(Rhino.version != "")
        XCTAssert(Rhino.frameLength > 0)
        XCTAssert(Rhino.sampleRate > 0)
        XCTAssert(r.contextInfo != "")
        r.delete()
    }
    
    func testInitSuccessWithCustomModelPath() throws {
        let bundle = Bundle(for: type(of: self))
        let contextPath = bundle.path(forResource: "coffee_maker_ios", ofType: "rhn")!
        let modelPath = bundle.path(forResource: "rhino_params", ofType: "pv")!
        
        let r = try Rhino.init(
            accessKey: accessKey,
            contextPath: contextPath,
            modelPath: modelPath)
        XCTAssert(r.contextInfo != "")
        r.delete()
    }
    
    func testInitSuccessWithCustomSensitivity() throws {
        let bundle = Bundle(for: type(of: self))
        let contextPath = bundle.path(forResource: "coffee_maker_ios", ofType: "rhn")!
        
        let r = try Rhino.init(
            accessKey: accessKey,
            contextPath: contextPath,
            sensitivity: 0.7)
        XCTAssert(r.contextInfo != "")
        r.delete()
    }
    
    func testInitSuccessWithRequireEndpointOff() throws {
        let bundle = Bundle(for: type(of: self))
        let contextPath = bundle.path(forResource: "coffee_maker_ios", ofType: "rhn")!
        
        let r = try Rhino.init(
            accessKey: accessKey,
            contextPath: contextPath,
            requireEndpoint: false)
        XCTAssert(r.contextInfo != "")
        r.delete()
    }
    
    func testInitSuccessDE() throws {
        let bundle = Bundle(for: type(of: self))
        let contextPath = bundle.path(forResource: "beleuchtung_ios", ofType: "rhn")!
        let modelPath = bundle.path(forResource: "rhino_params_de", ofType: "pv")!
        
        let r = try Rhino.init(
            accessKey: accessKey,
            contextPath: contextPath,
            modelPath: modelPath)
        XCTAssert(r.contextInfo != "")
        r.delete()
    }
    
    func testInitSuccessES() throws {
        let bundle = Bundle(for: type(of: self))
        let contextPath = bundle.path(forResource: "iluminación_inteligente_ios", ofType: "rhn")!
        let modelPath = bundle.path(forResource: "rhino_params_es", ofType: "pv")!
        
        let r = try Rhino.init(
            accessKey: accessKey,
            contextPath: contextPath,
            modelPath: modelPath)
        XCTAssert(r.contextInfo != "")
        r.delete()
    }
    
    func testInitSuccessFR() throws {
        let bundle = Bundle(for: type(of: self))
        let contextPath = bundle.path(forResource: "éclairage_intelligent_ios", ofType: "rhn")!
        let modelPath = bundle.path(forResource: "rhino_params_fr", ofType: "pv")!
        
        let r = try Rhino.init(
            accessKey: accessKey,
            contextPath: contextPath,
            modelPath: modelPath)
        XCTAssert(r.contextInfo != "")
        r.delete()
    }
    
    func testInitFailWithMismatchedLanguage() throws {
        let bundle = Bundle(for: type(of: self))
        let contextPath = bundle.path(forResource: "beleuchtung_ios", ofType: "rhn")!
        let modelPath = bundle.path(forResource: "rhino_params", ofType: "pv")!
        
        var didFail = false
        do {
            _ = try Rhino.init(
                accessKey: accessKey,
                contextPath: contextPath,
                modelPath: modelPath)
        } catch {
            didFail = true
        }
        
        XCTAssert(didFail)
    }
    
    func testInitFailWithInvalidContextPath() throws {
        let contextPath = "/bad_path/bad_path.rhn"
        
        var didFail = false
        do {
            _ = try Rhino.init(
                accessKey: accessKey,
                contextPath: contextPath)
        } catch {
            didFail = true
        }
        
        XCTAssert(didFail)
    }
    
    func testInitFailWithInvalidModelPath() throws {
        let bundle = Bundle(for: type(of: self))
        let contextPath = bundle.path(forResource: "coffee_maker_ios", ofType: "rhn")!
        let modelPath = "/bad_path/bad_path.pv"
        
        var didFail = false
        do {
            _ = try Rhino.init(
                accessKey: accessKey,
                contextPath: contextPath,
                modelPath: modelPath)
        } catch {
            didFail = true
        }
        
        XCTAssert(didFail)
    }
    
    func testInitFailWithInvalidSensitivity() throws {
        let bundle = Bundle(for: type(of: self))
        let contextPath = bundle.path(forResource: "coffee_maker_ios", ofType: "rhn")!
        
        var didFail = false
        do {
            _ = try Rhino.init(
                accessKey: accessKey,
                contextPath: contextPath,
                sensitivity: 10)
        } catch {
            didFail = true
        }
        
        XCTAssert(didFail)
    }
    
    func testInitFailWithWrongPlatform() throws {
        let bundle = Bundle(for: type(of: self))
        let contextPath = bundle.path(forResource: "coffee_maker_linux", ofType: "rhn")!
        
        var didFail = false
        do {
            _ = try Rhino.init(
                accessKey: accessKey,
                contextPath: contextPath)
        } catch {
            didFail = true
        }
        
        XCTAssert(didFail)
    }
    
    func testProcWithinContext() throws {
        let bundle = Bundle(for: type(of: self))
        let contextPath = bundle.path(forResource: "coffee_maker_ios", ofType: "rhn")!
        let r = try Rhino.init(
            accessKey: accessKey,
            contextPath: contextPath)
        
        let fileURL:URL = bundle.url(forResource: "test_within_context", withExtension: "wav")!
        let data = try Data(contentsOf: fileURL)
        let frameLengthBytes = Int(Rhino.frameLength) * 2
        var pcmBuffer = Array<Int16>(repeating: 0, count: Int(Rhino.frameLength))
        var isFinalized = false
        var index = 44
        while(index + frameLengthBytes < data.count) {
            _ = pcmBuffer.withUnsafeMutableBytes { data.copyBytes(to: $0, from: index..<(index + frameLengthBytes)) }
            isFinalized = try r.process(pcm:pcmBuffer)
            if isFinalized {
                break;
            }
            
            index += frameLengthBytes
        }
        
        XCTAssert(isFinalized)
        
        let inference:Inference = try r.getInference()
        XCTAssert(inference.isUnderstood)
        XCTAssert(inference.intent == "orderBeverage")
        
        let expectedSlotValues = [
            "size": "medium",
            "numberOfShots": "double shot",
            "beverage": "americano"
        ]
        
        XCTAssert(expectedSlotValues == inference.slots)
        
        r.delete()
    }
    
    func testProcOutOfContext() throws {
        let bundle = Bundle(for: type(of: self))
        let contextPath = bundle.path(forResource: "coffee_maker_ios", ofType: "rhn")!
        let r = try Rhino.init(
            accessKey: accessKey,
            contextPath: contextPath)
        
        let fileURL:URL = bundle.url(forResource: "test_out_of_context", withExtension: "wav")!
        let data = try Data(contentsOf: fileURL)
        let frameLengthBytes = Int(Rhino.frameLength) * 2
        var pcmBuffer = Array<Int16>(repeating: 0, count: Int(Rhino.frameLength))
        var isFinalized = false
        var index = 44
        while(index + frameLengthBytes < data.count) {
            _ = pcmBuffer.withUnsafeMutableBytes { data.copyBytes(to: $0, from: index..<(index + frameLengthBytes)) }
            isFinalized = try r.process(pcm:pcmBuffer)
            if isFinalized {
                break;
            }
            
            index += frameLengthBytes
        }
        
        XCTAssert(isFinalized)
        
        let inference:Inference = try r.getInference()
        XCTAssert(!inference.isUnderstood)
        
        r.delete()
    }

    func testInitWithNonAsciiModelName() throws {
        let bundle = Bundle(for: type(of: self))
        let contextPath = bundle.path(forResource: "iluminación_inteligente_ios", ofType: "rhn")!
        let modelPath = bundle.path(forResource: "rhino_params_es", ofType: "pv")!
        
        let r = try Rhino.init(
            accessKey: accessKey,
            contextPath: contextPath,
            modelPath: modelPath)
        XCTAssert(r.contextInfo != "")
        r.delete()
    }
}
