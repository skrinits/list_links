RSpec.describe Web::Views::Pages::Create, type: :view do
  let(:exposures) { Hash[format: :json, params: params] }
  let(:params) { instance_double('Hanami::Action::Params') }
  let(:view)      { described_class.new(nil, exposures) }
  let(:rendered)  { view.render }

  context 'если ссылки валидны' do
    before { allow(params).to receive(:valid?).and_return(true) }

    it { expect(rendered).to eq("{\"success\":true}") }
  end

  context 'если ссылки невалидны' do
    before do
      allow(params).to receive(:valid?).and_return(false)
      allow(params).to receive(:errors).and_return({ links: 'Неправильно задан урл' })
    end

    it { expect(rendered).to eq("{\"errors\":[\"Неправильно задан урл\"]}") }
  end
end
