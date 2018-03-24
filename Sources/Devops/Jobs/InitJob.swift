import Foundation

// TODO: rename to init-project
// TODO: render Dockerfile, help charts, how-to-deploy, etc.
// TODO: check if files exist
// TODO: add --force option
// TODO: emit instructions how-to-deploy, etc.

/// Intialize the package for mangement by `dop`.
public class InitJob: DevopsJob {
    public var dockerfileContents: String {
        return (
            """
            FROM ibmcom/swift-ubuntu-runtime:4.0.3
            LABEL Description="\(project.description)"
            MAINTAINER \(project.maintainer ?? "Unknown")
            
            RUN apt-get update # && apt-get install -y libpq-dev

            WORKDIR /root

            COPY .build/release/\(project.executableName) bin/\(project.executableName)

            ENV LD_LIBRARY_PATH /usr/lib/swift/linux

            CMD bin/\(project.executableName)
            """
        )
    }

    public var chartYAMLContents: String {
        return (
            """
            apiVersion: v1
            description: \(project.description)
            name: \(project.name)
            version: \(project.version)
            """
        )
    }

    public var valuesYAMLContents: String {
        return (
            """
            tag: \(project.version)
            """
        )
    }

    public var deploymentYAMLContents: String {
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
            image: registry.ng.bluemix.net/reizu/\(project.name):{{ .Values.image.tag }}
            # ports:
            # - containerPort: 80
            """
        )
    }

    public override func run() {
        do {
            try shell.writeTextFile(atPath: "Dockerfile", contents: dockerfileContents)

            try shell.ensureDirectoryExists(atPath: project.chartPath)
            try shell.writeTextFile(atPath: "\(project.chartPath)/Chart.yaml", contents: chartYAMLContents)
            try shell.writeTextFile(atPath: "\(project.chartPath)/values.yaml", contents: valuesYAMLContents)

            try shell.ensureDirectoryExists(atPath: "\(project.chartPath)/charts")

            try shell.ensureDirectoryExists(atPath: "\(project.chartPath)/templates")
            try shell.writeTextFile(atPath: "\(project.chartPath)/templates/deployment.yaml", contents: deploymentYAMLContents)
        } catch {
            print(error.localizedDescription)
        }
    }
}
