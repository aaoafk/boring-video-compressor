require "test_helper"
require "imghdr"

class ImghdrTest < ActiveSupport::TestCase
    def test_jpeg_file
        assert_equal 'jpeg', Imghdr.what("#{Rails.root}/test/fixtures/files/sample.jpg")
    end
 
    def test_png_file
        assert_equal 'png', Imghdr.what("#{Rails.root}/test/fixtures/files/sample.png")
    end
 
    def test_gif_file
        assert_equal 'gif', Imghdr.what("#{Rails.root}/test/fixtures/files/sample.gif")
    end

    def test_non_image_file
        assert_nil Imghdr.what("#{Rails.root}/test/fixtures/files/sample.txt")
    end
   
    def test_empty_file
        assert_nil Imghdr.what("#{Rails.root}/test/fixtures/files/empty.txt")
    end
end