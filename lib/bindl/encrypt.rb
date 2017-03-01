require 'open3'
require 'shellwords'

module Bindl
  class Encrypt
    class GPGError < RuntimeError; end

    def initialize(id)
      @id = id
    end

    def encrypt(data)
      pipe_to_stdin command('--encrypt'), data
    end

    def decrypt(data)
      pipe_to_stdin command('--decrypt'), data
    end

    private def pipe_to_stdin(cmd, data)
      res, status, errmsg = nil
      Open3.popen3(cmd) do |input, output, error, thread|
        input.write(data)
        input.close_write
        res = output.read
        errmsg = error.read
        status = thread.value
      end
      raise(GPGError, "gpg error #{errmsg}") if status.exitstatus != 0
      res
    end

    private def command(*extra)
      cmd = `which gpg2`.strip || `which gpg`.strip
      raise(GPGError, 'gpg not found') unless cmd
      args = ['--no-tty', "--recipient=#{@id}"]
      Shellwords.join([cmd].concat(args, extra))
    end
  end
end
