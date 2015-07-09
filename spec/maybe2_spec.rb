RSpec.describe Maybe do
  it 'unwraps to the same string' do
    expect(Maybe.new('Hello world').unwrap).to eq('Hello world')
  end

  it 'upcase.reverse unwraps to a string' do
    expect(Maybe.new('Hello world').upcase.reverse.unwrap).to eq('DLROW OLLEH')
  end

  it 'upcase.reverse unwraps to a nil' do
    expect(Maybe.new(nil).upcase.reverse.unwrap).to eq(nil)
  end

  it 'chain unwraps to a string' do
    value = Maybe.new('Hello world')
            .chain(&:upcase)
            .chain(&:reverse)
            .unwrap

    expect(value).to eq('DLROW OLLEH')
  end

  it 'chain unwraps to a nil' do
    value = Maybe.new('Hello world')
            .chain { |_string| nil }
            .chain(&:reverse)
            .unwrap

    expect(value).to eq(nil)
  end

  it 'string respond_to? size' do
    maybe = Maybe.new('Hello world').upcase.reverse
    expect(maybe.respond_to?(:size)).to eq(true)
  end

  it 'nil does not respond_to? size' do
    maybe = Maybe.new(nil).upcase.reverse
    expect(maybe.respond_to?(:size)).to eq(false)
  end

  context 'JSON example' do
    let(:good_response) do
      {
        data: {
          item: {
            name: 'Hello!'
          }
        }
      }
    end

    let(:bad_response) do
      {
        data: {}
      }
    end

    it 'good response unwraps to a string' do
      expect(Maybe.new(good_response)[:data][:item][:name].upcase.unwrap)
        .to eq('HELLO!')
    end

    it 'bad response unwraps to a nil' do
      expect(Maybe.new(bad_response)[:data][:item][:name].upcase.unwrap)
        .to eq(nil)
    end
  end
end
