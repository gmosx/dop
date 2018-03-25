public class Templates {
    let project: Project
    
    public init(project: Project) {
        self.project = project
    }

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
            apiVersion: apps/v1beta1
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
                    image: registry.ng.bluemix.net/reizu/\(project.name):{{ .Values.tag }}
                  # ports:
                  # - containerPort: 80
            """
        )
    }
}
