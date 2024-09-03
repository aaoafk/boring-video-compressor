require "test_helper"

class VideosControllerTest < ActionDispatch::IntegrationTest
  test 'should compress video' do
    post compress_video_path, params: { input_file: fixture_file_upload('sample_video.mp4', 'video/mp4') }
    assert_response :success
    assert_equal 'application/octet-stream', response.headers['Content-Type']
    assert_equal 'attachment; filename="compressed_sample_video.mp4"', response.headers['Content-Disposition']
  end
  
  test 'should clean up compressed files' do
    post compress_video_path, params: { input_file: fixture_file_upload('sample_video.mp4', 'video/mp4') }
    output_file = assigns(:output_file)
    assert File.exist?(output_file)
    get root_path
    assert_not File.exist?(output_file)
  end
end