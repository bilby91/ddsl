# frozen_string_literal: true

require_relative '../base'

module DDSL
  module Command
    module Docker
      class Build < Base
        executable 'docker'
        command 'build'

        options do
          accept_keys(%w[
                        build_args file cache_from tags labels rm
                      ])

          rename_keys(
            'build_args' => 'build_arg',
            'tags' => 'tag',
            'labels' => 'label'
          )

          optionize_keys
          expand_options
        end

        arguments do
          accept_keys(['context'])
        end

        after do |spec|
          spec['tags'].each { |t| Push.new(shell).run('image' => t) } if spec['push'] && spec['tags'].count.positive?
        end
      end
    end
  end
end
