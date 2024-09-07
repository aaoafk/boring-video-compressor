class VideosController < ApplicationController
  def compress
    input_file = params[:input_file]
    # Construct the path for the compressed video file
    squeezed_file_path = generate_unique_filename(input_file.original_filename)
    # Check if the uploaded file is a valid video file
    if Imghdr.valid_content_type?(input_file.content_type) && Imghdr.what(input_file.path).in?(Imghdr::VALID_FILE_EXTENSIONS)
      if compress_video(input_file.path, squeezed_file_path)
        # Video compression successful
        send_data squeezed_file_path, filename: "#{squeezed_file_path}", type: "application/octet-stream", disposition: "attachment"
      else
        # Video compression failed
        redirect_to root_path, alert: "There was an error compressing your media."
      end
    else
      Rails.logger.error("Invalid file type: #{squeezed_file_path}")
      redirect_to root_path, alert: "Invalid file type. Please upload a valid media file."
    end
  end

  def generate_unique_filename(previous_filename)
    # Create the directory for storing compressed files, if it doesn't exist
    compressed_files_dir = Rails.root.join("tmp", "uploads")
    FileUtils.mkdir_p(compressed_files_dir)

    unique_id = SecureRandom.uuid
    file_extension = previous_filename.split(".").second
    file_name = previous_filename.split(".").first
    File.join(compressed_files_dir, "#{file_name}-#{unique_id}.#{file_extension}")
  end

  private
  def compress_video(input_file_path, output_file_path)
    command = "ffmpeg -i #{input_file_path} -c:v libx264 -crf 28 #{output_file_path}"
    stdout, stderr, status = Open3.capture3(command)

    if status.success?
      Rails.logger.info("Media compression successful: #{stdout}")
      true
    else
      Rails.logger.error("Media compression failed: #{stderr}")
      false
    end
  end
end
