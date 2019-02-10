require 'test_helper'

class ErrorsControllerTest < ActionDispatch::IntegrationTest
    test "404 Not Found" do
        get "/404"

        assert_response 404
        assert_select "title", "Error 404 - Moeverdose"
    end

    test "500 Internal Server Error" do
        get "/500"

        assert_response 500
        assert_select "title", "Error 500 - Moeverdose"
    end

    test "Other Errors Codes" do
        error = [400, 408, 422, 502, 503, 504].sample
        get "/" + error.to_s

        assert_response error
        assert_select "title", "Error " + error.to_s + " - Moeverdose"
    end
end
