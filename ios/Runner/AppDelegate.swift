import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let json = readJSONFromFile(fileName: "secrets")
    if let jsonResult = json as? Dictionary<String, AnyObject>, let key = jsonResult["google_maps_sdk_api"] as? String {
        GMSServices.provideAPIKey(key)
    }
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    func readJSONFromFile(fileName: String) -> Any?
    {
        var json: Any?
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                // get json file
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            } catch {
                // catch error here...
                print("Unable to deserialize")
            }
        }
        return json
    }
}
