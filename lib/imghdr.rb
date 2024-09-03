require 'pathname'

module Imghdr
  # Recognize image file formats based on their first few bytes.
  extend self

  TESTS = []

  VALID_MIME_TYPES = {
    'jpeg' => ['image/jpeg', 'image/pjpeg'],
    'png' => ['image/png'],
    'gif' => ['image/gif'],
    'tiff' => ['image/tiff'],
    'rgb' => ['image/x-rgb'],
    'pbm' => ['image/x-portable-bitmap'],
    'pgm' => ['image/x-portable-graymap'],
    'ppm' => ['image/x-portable-pixmap'],
    'rast' => ['image/cmu-raster'],
    'xbm' => ['image/x-xbitmap'],
    'bmp' => ['image/bmp', 'image/x-windows-bmp'],
    'webp' => ['image/webp'],
    'exr' => ['image/x-exr'],
    'mov' => ['video/quicktime']
  }.freeze

  VALID_FILE_EXTENSIONS = VALID_MIME_TYPES.keys.freeze

  class << self
    def what(file, h = nil)
      begin
        if h.nil?
          if file.is_a?(String) || file.is_a?(Pathname)
            f = File.open(file, 'r')
            h = f.read(32)
            begin
                h.encode!(Encoding::UTF_8)
            rescue EncodingError
                h.force_encoding(Encoding::UTF_8)
            end
          else
            file.rewind # Run it back to the beginning
            h = file.read(32)
            begin
                h.encode!(Encoding::UTF_8)
            rescue EncodingError
                h.force_encoding(Encoding::UTF_8)
            end
          end
        end
        return nil if h.nil? || h.empty?
        TESTS.each do |test|
          res = test.call(h, f)
          return res if res
        end
      ensure
        f&.close
      end
      nil
    end

    def valid_content_type?(content_type)
        Imghdr::VALID_MIME_TYPES.any? { |_, types| types.include?(content_type) }
    end
  end

  def test_jpeg(h, f)
    if h[6..9] == 'JFIF' || h[6..9] == 'Exif'
      'jpeg'
    elsif h[0..3] == "\xFF\xD8\xFF\xDB"
      'jpeg'
    end
  end

  def test_png(h, f)
    'png' if h.start_with?("\x89PNG\r\n\x1A\n")
  end

  def test_gif(h, f)
    'gif' if ['GIF87a', 'GIF89a'].include?(h[0..5])
  end

  def test_tiff(h, f)
    'tiff' if ['MM', 'II'].include?(h[0..1])
  end

  def test_rgb(h, f)
    'rgb' if h.start_with?("\x01\xDA")
  end

  def test_pbm(h, f)
    'pbm' if h.length >= 3 && h[0] == 'P'.ord && h[1].chr =~ /[14]/ && h[2].chr =~ /[ \t\n\r]/
  end

  def test_pgm(h, f)
    'pgm' if h.length >= 3 && h[0] == 'P'.ord && h[1].chr =~ /[25]/ && h[2].chr =~ /[ \t\n\r]/
  end

  def test_ppm(h, f)
    'ppm' if h.length >= 3 && h[0] == 'P'.ord && h[1].chr =~ /[36]/ && h[2].chr =~ /[ \t\n\r]/
  end

  def test_rast(h, f)
    'rast' if h.start_with?("\x59\xA6\x6A\x95")
  end

  def test_xbm(h, f)
    'xbm' if h.start_with?('#define ')
  end

  def test_bmp(h, f)
    'bmp' if h.start_with?('BM')
  end

  def test_webp(h, f)
    'webp' if h.start_with?('RIFF') && h[8..11] == 'WEBP'
  end

  def test_exr(h, f)
    'exr' if h.start_with?("\x76\x2F\x31\x01")
  end
  
  def test_mov(h, f)
    'mov' if h[4..7] == 'ftyp'
  end

  TESTS.concat([
    method(:test_jpeg),
    method(:test_png),
    method(:test_gif),
    method(:test_tiff),
    method(:test_rgb),
    method(:test_pbm),
    method(:test_pgm),
    method(:test_ppm),
    method(:test_rast),
    method(:test_xbm),
    method(:test_bmp),
    method(:test_webp),
    method(:test_exr),
    method(:test_mov)
  ])
end