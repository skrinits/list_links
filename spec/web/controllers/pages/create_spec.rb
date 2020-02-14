RSpec.describe Web::Controllers::Pages::Create, type: :action do
  let(:action) { described_class.new }
  let(:params) { Hash[links: links] }

  context 'если все ссылки валидны' do
    let(:links) { %w[https://www.rubydoc.info/ https://guides.hanamirb.org/actions/parameters/] }

    it 'вызовет обрабочика ссылок' do
      links.each do |link|
        expect(LinksHandler).to receive(:perform_async).with(link)
      end
      expect(LinksHandler).to receive(:wait)

      action.call(params)
    end
  end

  context 'если есть хоть одна ссылка невалидна' do
    let(:links) { %w[rubydoc.info/ https://guides.hanamirb.org/actions/parameters/] }

    it do
      expect(LinksHandler).not_to receive(:perform_async)
      expect(LinksHandler).not_to receive(:wait)

      action.call(params)
    end
  end
end
