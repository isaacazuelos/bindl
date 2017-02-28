require 'shellwords'

module Bindl
  class Encrypt
    class GPGError < RuntimeError; end

    def initialize(store)
      @store = store
    end

    def encrypt(data)
      pipe_to_stdin command('--encrypt'), data
    end

    def decrypt(data)
      pipe_to_stdin command('--decrypt'), data
    end

    def id
      Shellwords.escape @store.meta.get 'encryption.gpg-id'
    end

    private def pipe_to_stdin(cmd, data)
      IO.popen(cmd, 'r+') do |pipe|
        pipe.write data
        pipe.close_write
        pipe.read
      end
    end

    private def command(*extra)
      cmd = `which gpg2`.strip || `which gpg`.strip
      raise(GPGError, 'gpg not found') unless cmd
      Shellwords.join([cmd, "--recipient=#{id}"].concat(extra))
    end
  end
end
