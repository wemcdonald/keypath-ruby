# test helpers
require File.expand_path 'spec_helper.rb', __dir__

describe 'EnumerableExtensions' do
  it 'adds methods to collections' do
    hash = {:id => 1}

    hash.must_respond_to 'value_at_keypath'
    hash.must_respond_to 'set_keypath'
  end

  it 'can fetch simple path values' do
    hash = {:id => 1}

    hash.value_at_keypath('id').must_equal 1
  end

  it 'can accept KeyPath::Path objects for keypaths' do
    hash = {:id => 1}
    keypath = KeyPath::Path.new('id')

    hash.value_at_keypath(keypath).must_equal 1
  end


  it 'can fetch with a nested hash key path' do
    hash = {:item => {:id => 1}}

    hash.value_at_keypath('item.id').must_equal 1
  end

  it 'can fetch a nested array object' do
    hash = {:items => [{:id => 1}]}

    hash.value_at_keypath('items.0').must_equal({:id => 1})
  end

end
