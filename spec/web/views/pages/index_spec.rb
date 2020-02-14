RSpec.describe Web::Views::Pages::Index, type: :view do
  let(:exposures) { Hash[format: :html, pages: pages] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/pages/index.html.erb') }
  let(:view)      { described_class.new(template, exposures) }
  let(:rendered)  { view.render }
  let(:pages) { build_list(:page, 3) }

  it 'отрендерит шаблон без ошибки' do
    expect { rendered }.not_to raise_error
  end
end
