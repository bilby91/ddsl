# frozen_string_literal: true

require 'rspec/expectations'

RSpec::Matchers.define :have_tag do |expected_tag|
  include DockerHelper

  match do |actual_image|
    get_image_info(actual_image)['RepoTags'].include?(expected_tag)
  end
end

RSpec::Matchers.define :have_build_arg do |expected_build_arg|
  include DockerHelper

  match do |actual_image|
    get_image_info(actual_image)['ContainerConfig']['Cmd'].include?(expected_build_arg)
  end
end
