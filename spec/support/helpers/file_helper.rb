# frozen_string_literal: true

require 'tempfile'

module FileHelper
  def tmp_dir
    Dir.mktmpdir
  end

  def tmp_file(name, content = nil)
    file = new_writable_tmp_file(name)
    file.write content unless content.nil?
    file.close

    file
  end

  def new_writable_tmp_file(name)
    new_writable_file(File.join(tmp_dir, name))
  end

  def new_writable_file(name)
    File.new(name, 'w')
  end
end
