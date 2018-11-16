# frozen_string_literal: true

module DockerHelper
  def get_image_info(image)
    runner.get_image(image.info['id']).info
  end

  private def runner
    DDSL::DockerRunner.new
  end
end
