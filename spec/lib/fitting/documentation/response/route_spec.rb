require 'spec_helper'
require 'multi_json'

RSpec.describe Fitting::Documentation::Response::Route do
  let(:responses) { [{'status' => '200'}] }
  let(:tomogram) { MultiJson.dump(['path': "/sessions", 'method': "POST", 'request': {}, 'responses': responses]) }
  let(:coverage_responses) { [double(route: "POST\t/sessions 200 0", documented?: true, valid?: true)] }
  let(:responses_routes) { ["POST\t/sessions 200 0"] }

  subject { described_class.new(coverage_responses, responses_routes) }

  describe '.new' do
    it 'returns described class object' do
      expect(subject).to be_a(described_class)
    end
  end

  describe '#coverage' do
    it 'returns coverage routes' do
      expect(subject.coverage).to eq(["POST\t/sessions 200 0"])
    end
  end

  describe '#not_coverage' do
    let(:coverage_responses) { [] }

    it 'returns not coverage routes' do
      expect(subject.not_coverage).to eq(["POST\t/sessions 200 0"])
    end
  end

  describe '#cover_ratio' do
    it 'returns cover ratio routes' do
      expect(subject.cover_ratio).to eq(100.to_f)
    end
  end

  describe '#to_hash' do
    it 'returns hash routes' do
      expect(subject.to_hash).to eq({'coverage' => ["POST\t/sessions 200 0"], 'not coverage' => []})
    end
  end

  describe '#statistics_with_conformity_lists' do
    before { allow(STDOUT).to receive(:puts) }

    it 'does not return error' do
      expect { subject.statistics_with_conformity_lists }.not_to raise_error
    end
  end
end
