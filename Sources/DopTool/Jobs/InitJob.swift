import Foundation
import Common

// TODO: render Dockerfile, help charts, how-to-deploy, etc.
// TODO: check if files exist
// TODO: add --force option
// TODO: consider emitting a templetized deployment.yaml
// TODO: consider renaming to apply.yaml

/// Intialize the package for mangement by `dop`.
public class InitJob: Job {
    let projectDescriptor: ProjectDescriptor
    
    public init(projectDescriptor: ProjectDescriptor) {
        self.projectDescriptor = projectDescriptor
    }
    
    private func renderDockerfileContents() -> String {
        let pd = projectDescriptor

        return (
            """
            FROM ibmcom/swift-ubuntu-runtime:4.0.3

            MAINTAINER \(pd.maintainer ?? "gmosx@reizu.com")
            LABEL Description="\(pd.description)"

            RUN apt-get update # && apt-get install -y libpq-dev

            WORKDIR /root

            COPY .build/release/\(pd.executableName) bin/\(pd.executableName)

            ENV LD_LIBRARY_PATH /usr/lib/swift/linux

            CMD bin/\(pd.executableName)
            """
        )
    }

//    private func renderDockerfileToolsContents() -> String {
//        let pd = projectDescriptor
//
//        return (
//            """
//            FROM ibmcom/swift-ubuntu:4.0.3
//            MAINTAINER gmosx@reizu.com
//            LABEL Description="Swift Build Container Image"
//
//            RUN apt-get update && apt-get install -y libpq-dev
//            RUN cd /root/Code/\(pd.packagePath)
//            RUN swift package clean
//            RUN swift package update
//            RUN swift build --configuration=release
//            """
//        )
//    }

    private func renderDeploymentYAMLContents() -> String {
        let pd = projectDescriptor

        return (
            """
            apiVersion: extensions/v1beta1
            kind: Deployment
            metadata:
              name: \(pd.name)-deployment
            spec:
              replicas: 1
              template:
                metadata:
                  labels:
                    app: \(pd.name)
                spec:
                  containers:
                  - name: \(pd.name)
                    image: registry.ng.bluemix.net/reizu/\(pd.name):\(pd.version)
                    # ports:
                    # - containerPort: 80
            """
        )
    }

    public func run() {
        do {
            let dockerfileContents = renderDockerfileContents()
            print("Creating 'Dockerfile'...", terminator: " ")
            try dockerfileContents.write(to: URL(fileURLWithPath: "Dockerfile"), atomically: false, encoding: .utf8)
            print("DONE")

//            let dockerfileToolsContents = renderDockerfileToolsContents()
//            print("Creating 'Dockerfile.tools'...", terminator: " ")
//            try dockerfileToolsContents.write(to: URL(fileURLWithPath: "Dockerfile.tools"), atomically: false, encoding: .utf8)
//            print("DONE")

            let deploymentYAMLContents = renderDeploymentYAMLContents()
            print("Creating 'deployment.yaml'...", terminator: " ")
            try deploymentYAMLContents.write(to: URL(fileURLWithPath: "deployment.yaml"), atomically: false, encoding: .utf8)
            print("DONE")
        } catch {
            print(error.localizedDescription)
        }
    }
}
