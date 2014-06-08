require File.expand_path('../../../spec_helper', __FILE__)

describe JenkinsPipelineBuilder::Generator do
  let(:jenkins_api_client) { double JenkinsApi::Client }

  it 'generates publishers' do
    expect(jenkins_api_client).to receive :logger

    generator = JenkinsPipelineBuilder::Generator.new nil, jenkins_api_client

    expect(generator).to_not be_nil
  end
end