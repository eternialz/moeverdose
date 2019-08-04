require 'test_helper'

class TagServiceTest < ActiveSupport::TestCase

    setup do
    end

    test 'tag_sanitization' do
        assert_equal "abc", TagService.sanitize("_abc")
        assert_equal "abc", TagService.sanitize("abc_")
        assert_equal "abc", TagService.sanitize("_abc_")
        assert_equal "abc", TagService.sanitize("AbC")
        assert_equal "abc", TagService.sanitize("a*b~c")
        assert_equal "ab_c", TagService.sanitize("ab c")
        assert_equal "a_b_c", TagService.sanitize("a\nb    \nc   ")
    end
end
