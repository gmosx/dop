import Foundation

// TODO: render Dockerfile, help charts, how-to-deploy, etc.
// TODO: check if files exist
// TODO: add --force option
// TODO: consider emitting a templetized deployment.yaml
// TODO: consider renaming to apply.yaml
// TODO: emit instructions how-to-deploy, etc.

/// Intialize the package for mangement by `dop`.
public class InitJob: BaseToolJob {
    private func renderDockerfileContents() -> String {
        var contents: String = (
            """
            FROM ibmcom/swift-ubuntu-runtime:4.0.3\n
            """
        )

        if let description = project.description {
            contents += (
                """
                LABEL Description="\(description)"\n
                """
            )
        }

        if let maintainer = project.maintainer {
            contents += (
                """
                MAINTAINER \(maintainer)\n
                """
            )
        }

        contents += (
            """
            
            RUN apt-get uprojectate # && apt-get install -y libpq-dev

            WORKDIR /root

            COPY .build/release/\(project.executableName) bin/\(project.executableName)

            ENV LD_LIBRARY_PATH /usr/lib/swift/linux

            CMD bin/\(project.executableName)
            """
        )

        return contents
    }

    private func renderDeploymentYAMLContents() -> String {
        return (
            """
            apiVersion: extensions/v1beta1
            kind: Deployment
            metadata:
              name: \(project.name)-deployment
            spec:
              replicas: 1
              template:
                metadata:
                  labels:
                    app: \(project.name)
                spec:
                  containers:
                  - name: \(project.name)
                    image: registry.ng.bluemix.net/reizu/\(project.name):\(project.version)
                    # ports:
                    # - containerPort: 80
            """
        )
    }

    public override func run() {
        do {
            let dockerfileContents = renderDockerfileContents()
            print("Creating 'Dockerfile'...", terminator: " ")
            try dockerfileContents.write(to: URL(fileURLWithPath: "Dockerfile"), atomically: false, encoding: .utf8)
            print("DONE")

            let deploymentYAMLContents = renderDeploymentYAMLContents()
            print("Creating 'deployment.yaml'...", terminator: " ")
            try deploymentYAMLContents.write(to: URL(fileURLWithPath: "deployment.yaml"), atomically: false, encoding: .utf8)
            print("DONE")
        } catch {
            print(error.localizedDescription)
        }
    }
}
