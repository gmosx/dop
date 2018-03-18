import Foundation
import Common

let dockerfileTemplate = (
    """
    FROM ibmcom/swift-ubuntu-runtime:4.0.3
    
    MAINTAINER gmosx@reizu.com
    LABEL Description="Fund Notifications Runtime"
    
    RUN apt-get update # && apt-get install -y libpq-dev
    
    WORKDIR /root
    
    COPY .build/release/fund-notifications-server bin/fund-notifications-server
    
    ENV LD_LIBRARY_PATH /usr/lib/swift/linux
    
    CMD bin/fund-notifications-server
    """
)

public class InitJob: Job {
    public init() {
    }

    public func run() {
        do {
            let fileURL = URL(fileURLWithPath: "dop.json")
            let descriptorData = try Data(contentsOf: fileURL)

            let jsonDecoder = JSONDecoder()
            let descriptor = try jsonDecoder.decode(ProjectDescriptor.self, from: descriptorData)

            print(descriptor)
        } catch {
            print(error.localizedDescription)
        }
    }
}
