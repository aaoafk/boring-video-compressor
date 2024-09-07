require "fileutils"

class VideosController < ApplicationController
  def compress
    input_file = params[:input_file]

    # Check if the uploaded file is a valid video file
    if Imghdr.valid_content_type?(input_file.content_type) && Imghdr.what(input_file.path).in?(Imghdr::VALID_FILE_EXTENSIONS)
      # Create the directory for storing compressed files, if it doesn't exist
      compressed_files_dir = Rails.root.join("tmp", "uploads")
      FileUtils.mkdir_p(compressed_files_dir)

      # Construct the path for the compressed video file
      compressed_file_path = File.join(compressed_files_dir, "compressed_#{input_file.original_filename}")

      # Execute FFmpeg command to compress the video
      command = "ffmpeg -i #{input_file.path} -c:v libx264 -crf 28 #{compressed_file_path}"
      stdout, stderr, status = Open3.capture3(command)

      if status.success?
        # Video compression successful
        send_data compressed_file_path, filename: "compressed_#{input_file.original_filename}", type: "application/octet-stream", disposition: "attachment"
      else
        # Video compression failed
        redirect_to root_path, alert: "Error compressing video: #{stderr}"
      end
    else
      Rails.logger.error("Invalid file type")
      redirect_to root_path, alert: "Invalid file type. Please upload a video file."
    end
  end
end
