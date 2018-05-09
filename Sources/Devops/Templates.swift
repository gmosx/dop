public class Templates {
    let project: Project

    public init(project: Project) {
        self.project = project
    }

    private var aptGetUpdateRunCommand: String {
        let installAptPackages = project.systemPackages.isEmpty
            ? ""
            : "\n\(project.systemPackages.map({ "RUN apt-get install -y \($0)" }).joined(separator: "\n"))"

        return "RUN apt-get update\(installAptPackages)"
    }

    public var dockerfileContents: String {
        return (
            """
            FROM ibmcom/swift-ubuntu-runtime:\(project.swiftVersion)
            LABEL Description="\(project.description)"
            MAINTAINER \(project.maintainer ?? "Unknown")

            \(aptGetUpdateRunCommand)

            WORKDIR /root

            COPY .build/release/\(project.executableName) bin/\(project.executableName)

            ENV LD_LIBRARY_PATH /usr/lib/swift/linux

            CMD bin/\(project.executableName)
            """
        )
    }

    public var dockerfileToolsContents: String {
        return (
            """
            FROM ibmcom/swift-ubuntu:\(project.swiftVersion)
            LABEL Description="Swift Tools Container for '\(project.name)'"
            MAINTAINER \(project.maintainer ?? "Unknown")

            \(aptGetUpdateRunCommand)
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

            ## Building a new release

            First of all, ensure that the `docker` daemon is running.

            ```
            dop version-bump
            dop image-build
            ```

            Check that everything is OK by running the image locally:

            ```
            dop image-run
            ```

            ## Deploying a new release

            ### Registering the release image

            First of all, ensure that the `docker` daemon is running. Then
            make sure that the image is built following the steps in the
            previous section.

            ```
            eval $(dop login)
            dop image-push
            ```

            ### Manual deployment

            ```
            helm template \(project.chartPath) > deployment.yaml
            kubectl apply -f deployment.yaml
            ```

            ### Deployment with Helm

            ```
            helm package \(project.chartPath)
            helm upgrade \(project.helmPackagePath)
            ```

            ## Useful kubectl commands

            ```
            # Show all deployments
            kubectl get deployment

            # Show all pods
            kubectl get pods

            # Sho details of the project's deployment
            kubectl describe deployment <deployment-name>

            # Show the logs of the pod
            kubectl logs <pod-name>
            ```
            """
        )
    }
}
