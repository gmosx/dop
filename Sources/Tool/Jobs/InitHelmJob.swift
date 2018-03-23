import Foundation

public class InitHelmJob: BaseToolJob {
    private var chartYAMLContents: String {
        return (
            """
            apiVersion: v1
            description: \(project.description)
            name: \(project.name)
            version: \(project.version)
            """
        )
    }

    private var valuesYAMLContents: String {
        return (
            """
            tag: \(project.version)
            """
        )
    }

    private var deploymentYAMLContents: String {
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
            let shell = Shell()
            
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
