require 'test_helper'

class TagServiceTest < ActiveSupport::TestCase
    setup do
        @tag = create(:tag_copyright)
        @author = create(:author)
    end

    test 'tag_sanitization' do
        assert_equal 'abc', TagService.sanitize('_abc')
        assert_equal 'abc', TagService.sanitize('abc_')
        assert_equal 'abc', TagService.sanitize('_abc_')
        assert_equal 'abc', TagService.sanitize('AbC')
        assert_equal 'abc', TagService.sanitize('a*b~c')
        assert_equal 'ab_c', TagService.sanitize('ab c')
        assert_equal 'a_b_c', TagService.sanitize("a\nb    \nc   ")
    end

    test 'Find existing tag' do
        @tag_count = Tag.count

        @found_tag = TagService.find_or_create(@tag.name, 'copyright', Post.new)

        assert_equal @tag.id, @found_tag.first.id
        assert_equal @tag_count, Tag.count
    end

    test 'Create non existing tag' do
        @tag_count = Tag.count

        @created_tag = TagService.find_or_create(SecureRandom.uuid, 'content', Post.new)

        assert_equal @tag_count + 1, Tag.count
    end

    # See https://github.com/eternialz/moeverdose/issues/45
    # test 'Find existing author and tag' do
    #     @tag_count = Tag.count
    #     @author_count = Author.count

    #     @found_author = TagService.find_or_create_author(@author.name, Post.new)

    #     assert_equal @author, @found_author

    #     assert_equal @tag_count, Tag.count
    #     assert_equal @author_count, Author.count
    # end

    test 'Create non existing author and tag' do
        @tag_count = Tag.count
        @author_count = Author.count

        @new_author = TagService.find_or_create_author(SecureRandom.uuid, Post.new)
        @new_author.save

        assert_equal @author_count + 1, Author.count
        assert_equal @tag_count + 1, Tag.count
    end
end
