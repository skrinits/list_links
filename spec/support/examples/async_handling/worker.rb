shared_examples 'async_handling handler' do
  let(:manager) { instance_double('AsyncHandling::Manager') }

  before { allow(AsyncHandling::Manager).to receive(:instance).and_return(manager) }

  it '.perform_async' do
    expect(manager).to receive(:execute).with(described_class, ['args'])

    described_class.perform_async('args')
  end

  it '.wait' do
    expect(manager).to receive(:wait)

    described_class.wait
  end
end
