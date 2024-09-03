class VideosController < ApplicationController
  def compress
    input_file = params[:input_file]
  
    # Check if the uploaded file is a valid video file
    if Imghdr.valid_content_type?(input_file) && Imghdr.what(input_file).in?(Imghdr::VALID_FILE_EXTENSIONS)
          # Create a temporary file for the compressed output
        Tempfile.create(['compressed_', ".#{input_file.original_filename.split('.').last}"]) do |output_file|
        # Execute FFmpeg command to compress the video
        command = "ffmpeg -i #{input_file.path} -c:v libx264 -crf 28 #{output_file.path}"
        stdout, stderr, status = Open3.capture3(command)

        if status.success?
          # Video compression successful
          send_file output_file.path, filename: "compressed_#{input_file.original_filename}", disposition: 'attachment'
        else
          # Video compression failed
          redirect_to root_path, alert: "Error compressing video: #{stderr}"
        end
      end
    else
      redirect_to root_path, alert: "Invalid file type. Please upload a video file."
      return
    end
  

  end
end