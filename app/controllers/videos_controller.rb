class VideosController < ApplicationController
  def compress
    input_file = params[:input_file]
    output_file = "#{Rails.root}/tmp/compressed_#{input_file.original_filename}"

    # Execute FFmpeg command to compress the video
    command = "ffmpeg -i #{input_file.path} -c:v libx264 -crf 28 #{output_file}"
    stdout, stderr, status = Open3.capture3(command)

    if status.success?
      # Video compression successful
      redirect_to download_video_path(output_file)
    else
      # Video compression failed
      redirect_to root_path, alert: "Error compressing video: #{stderr}"
    end
  end

  def download
    file_path = params[:file_path]
    send_file file_path, disposition: 'attachment'
  end
end