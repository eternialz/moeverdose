require 'test_helper'

class ZipServiceTest < ActiveSupport::TestCase
    test 'can_zip' do
        json = { pokemon: Faker::Games::Pokemon.name }
        json_name, zip_name = Faker::Games::Pokemon.name
        assert ZipService.create_from_json(json, json_name, zip_name)
    end
end
