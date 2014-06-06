require File.expand_path('../../../spec_helper', __FILE__)

describe JenkinsPipelineBuilder::Publishers do
  let (:builder) { Nokogiri::XML::Builder.new }
  let (:params) { {} }

  context 'junit publisher' do
    it 'generates configuration' do
      JenkinsPipelineBuilder::Publishers.publish_junit params, builder

      doc = builder.doc
      expect(doc.root.name).to match 'hudson.tasks.junit.JUnitResultArchiver'
    end

    it 'populates the path to the test results' do
      params[:test_results] = 'path/to/results.xml'

      builder = Nokogiri::XML::Builder.new

      JenkinsPipelineBuilder::Publishers.publish_junit params, builder

      junit_nodes = builder.doc.root.children
      test_results = junit_nodes.select { |node| node.name == 'testResults' }
      expect(test_results.first.content).to match 'results.xml'
    end
  end

  context 'sonar publisher' do
    it 'generates configuration' do
      JenkinsPipelineBuilder::Publishers.publish_sonar params, builder

      publisher = builder.doc.root
      expect(publisher.name).to match 'hudson.plugins.sonar.SonarPublisher'
      expect(publisher.attribute('plugin').value).to match 'sonar'
    end

    it 'populates branch'
    it 'populates maven installation name'
  end
end
