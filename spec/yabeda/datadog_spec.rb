# frozen_string_literal: true

RSpec.describe Yabeda::Datadog do
  it "has a version number" do
    expect(Yabeda::Datadog::VERSION).not_to be nil
  end

  describe "configuring" do
    it "requires API key" do
      described_class.config.api_key = nil
      described_class.config.app_key = "qwe"
      expect do
        described_class.start
      end.to raise_error(Yabeda::Datadog::ApiKeyError)
    end

    it "requires App key" do
      described_class.config.api_key = "qwe"
      described_class.config.app_key = nil
      expect do
        described_class.start
      end.to raise_error(Yabeda::Datadog::AppKeyError)
    end
  end

  describe "collect metrics from yabdeda collect blocks" do
    let(:collector) { instance_spy("Proc") }

    it "calls yabeda collectors" do
      ::Yabeda.collectors.push(collector)

      collector_loop = described_class.start_exporter(collect_interval: 0.1)
      sleep(0.1)
      expect(collector).to have_received(:call).with(no_args).at_least(:once)
      collector_loop.exit
    end
  end
end
