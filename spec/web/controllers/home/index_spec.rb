RSpec.describe Web::Controllers::Home::Index, type: :action do
  let(:action) { described_class.new }
  let(:params) { Hash[] }

  it 'вернет 200 ОК' do
    response = action.call(params)

    expect(response[0]).to eq(200)
  end
end
