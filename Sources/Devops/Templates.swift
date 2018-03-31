public class Templates {
    let project: Project
    
    public init(project: Project) {
        self.project = project
    }

    public var dockerfileContents: String {
        let installAptPackages = project.systemPackages.isEmpty
            ? ""
            : "\n\(project.systemPackages.map({ "RUN apt-get install -y \($0)"}).joined(separator: "\n"))"

        return (
            """
            FROM ibmcom/swift-ubuntu-runtime:4.0.3
            LABEL Description="\(project.description)"
            MAINTAINER \(project.maintainer ?? "Unknown")
            
            RUN apt-get update\(installAptPackages)

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
    
    public var devopsFileContents: String {
        return (
            """
            # Devops workflows

            ## Deploy a new release

            ### Preparation
            
            ```
            dop version-bump
            dop image-build
            eval $(dop login)
            dop image-push
            ```
            
            ### Manual deployment
            
            ```
            helm template \(project.chartPath)
            kubectl apply -f deployment.yaml
            ```
            
            ### Deployment with Helm
            
            ```
            helm package \(project.chartPath)
            helm upgrade \(project.helmPackagePath)
            ```
            
            ## Useful kubectl commands
            
            ```
            kubectl get deployment
            kubectl get pods
            kubectl logs <pod-name>
            ```
            """
        )
    }
}
