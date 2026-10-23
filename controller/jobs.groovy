// Job DSL seed: creates the demo pipeline from the Jenkinsfile baked into the image.
// The pipeline itself runs in the Groovy sandbox.
pipelineJob('multi-agent-demo') {
  description('Distributes stages across agents by label (CodeAlpha Task 2)')
  definition {
    cps {
      script(new File('/usr/share/jenkins/ref/pipelines/Jenkinsfile').text)
      sandbox(true)
    }
  }
}
