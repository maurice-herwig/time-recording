require "test_helper"

class WorkplaceTest < ActiveSupport::TestCase

  test "create new workplace" do
    # Create a new workplace
    workplace = Workplace.new(name: 'wp',
                              street_name: 'Willi Alle',
                              street_number: '1a',
                              city: 'kassel',
                              zip_code: 12345)

    # Assert that the workplace is valid
    assert workplace.save

    # Assert the values
    assert_equal workplace.name, 'wp'
    assert_equal workplace.address, 'Willi Alle 1a, 12345 kassel'
  end

  test 'name unique' do
    # Setup
    workplace = workplaces(:test_workplace)

    workplace2 = Workplace.new(name: workplace.name,
                               street_name: 'Willi Alle',
                               street_number: '1a',
                               city: 'kassel',
                               zip_code: 12345)

    # Assert that workplace name is unique
    assert_not workplace2.save
    assert_equal workplace2.errors.map(&:attribute), [:name]
  end
end
