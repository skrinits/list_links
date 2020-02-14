RSpec.describe AsyncHandling::Manager do
  subject(:manager) { described_class.instance }

  let(:handler_klass) { LinksHandler }
  let(:handler) { instance_double(handler_klass.name) }

  before { allow(handler_klass).to receive(:new).and_return(handler) }

  it '#execute' do
    expect(handler).to receive(:perform).with('args')

    manager.execute(handler_klass, 'args')
  end

  describe '#wait' do
    let(:thread) { instance_double('Thread') }

    before { manager.instance_variable_set(:@threads, [thread]) }

    it do
      expect(thread).to receive(:join)

      manager.wait
    end
  end
end
