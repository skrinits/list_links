require 'spec_helper'

RSpec.describe LinksHandler do
  it_behaves_like 'async_handling handler'

  describe '#perform' do
    subject(:perform) { described_class.new.perform(url) }

    let(:url) { 'https://guides.hanamirb.org/actions/parameters/' }
    let(:html) { '<html><head><title>title</title></head><body></body></html>' }
    let(:response) { instance_double('Typhoeus::Response ') }
    let(:repository) { instance_double('PageRepository') }
    let(:logger) { instance_double('Hanami::Logger') }

    before do
      allow(Typhoeus).to receive(:get).with(url).and_return(
        response
      )
      allow(response).to receive(:body).and_return(html)
      allow(response).to receive(:code).and_return(200)
      allow(PageRepository).to receive(:new).and_return(repository)
      allow(Hanami).to receive(:logger).and_return(logger)
    end

    context 'если страница не существует' do
      before { allow(repository).to receive(:find_by_url).and_return(nil) }

      it do
        expect(repository).to receive(:create).with(url: url, title: 'title', status: 200)
        expect(logger).to receive(:info).with("Created a page with url = #{ url }")

        perform
      end
    end

    context 'если страница существует' do
      context 'и создана до начала обработки' do
        before { allow(repository).to receive(:find_by_url).and_return(build(:page)) }

        it do
          expect(logger).to receive(:info).with("The page with url = #{ url } exists!")

          perform
        end
      end

      context 'и создана в другом потоке (нет вызова wait)' do
        before do
          allow(repository).to receive(:find_by_url).and_return(nil)
          allow(repository).to receive(:create).and_raise(Hanami::Model::UniqueConstraintViolationError)
        end

        it do
          expect(logger).to receive(:error).with('Unique constraint has been violated')

          perform
        end
      end
    end
  end
end
