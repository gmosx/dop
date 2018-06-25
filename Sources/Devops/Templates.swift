import Foundation

// TODO: split into multiple files.

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
            # Container dev-ops workflows

            ## Prepare the tools

            First of all, ensure that the `docker` daemon is running. Then,
            sign-in to IBM Cloud:

            ```
            eval $(dop login)
            ```

            ## Building the tools container

            Before building the application container, you need to build the
            'tools' container needed for compilation, etc:

            ```
            dop tools-image-build
            ```

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

            First, make sure that the image is built following the steps in the
            previous section.

            ```
            dop image-register
            ```

            You may want to remove previous images from the registry to make
            space:

            ```
            dop image-unregister <tag>
            ```

            ### Deployment with dop

            ```
            dop release-upgrade
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

    public var libraryDevopsFileContents: String {
        return (
            """
            # Devops workflows

            ## Setup github origin

            ```
            git remote add origin \(project.githubRepositoryURL)
            git push -u origin master
            ```

            ## Push new version to github

            ```
            git push
            ```
            """
        )
    }

    public var proprietaryLicenseContents: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let currentYear = dateFormatter.string(from: Date())

        return (
            """
            PROPRIETARY AND CONFIDENTIAL

            Copyright (c) \(currentYear) \(project.organizationName). All rights reserved.
            """
        )
    }

    public var mitLicenseContents: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let currentYear = dateFormatter.string(from: Date())

        return (
            """
            MIT License

            Copyright (c) \(currentYear) \(project.organizationName)

            Permission is hereby granted, free of charge, to any person obtaining a copy
            of this software and associated documentation files (the "Software"), to deal
            in the Software without restriction, including without limitation the rights
            to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
            copies of the Software, and to permit persons to whom the Software is
            furnished to do so, subject to the following conditions:

            The above copyright notice and this permission notice shall be included in all
            copies or substantial portions of the Software.

            THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
            IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
            FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
            AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
            LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
            OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
            SOFTWARE.
            """
        )
    }
}
