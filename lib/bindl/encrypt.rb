# Our class for working with encryption.
#
# This just pipes the data to `gpg2` or `gpg`, which is expected to be
# in the user's `$PATH`.
#
# GPG is called with the `--no-tty` flag set, to prevent it from dumping
# messages to the tty.

require 'open3'
require 'shellwords'

module Bindl
  # A wrapper around calls to `gpg` to encrypt and decrypt data.
  class Encrypt
    # Used to pass up any errors that occur working with GPG.
    class GPGError < RuntimeError; end

    # The `id` is the stirng that gets passed to `gpg` as the
    # recipient -- so it can be an email address or a hex key.
    def initialize(id)
      @id = id
    end

    # Encrypt some data using GPG.
    def encrypt(data)
      pipe_to_stdin command('--encrypt'), data
    end

    # Decrypt some data using GPG.
    def decrypt(data)
      pipe_to_stdin command('--decrypt'), data
    end

    # A wrapper around the subprocess call to GPG.
    private def pipe_to_stdin(cmd, data)
      res, errmsg = nil
      Open3.popen3(cmd) do |input, output, error, _thread|
        input.write(data)
        input.close_write
        res = output.read
        errmsg = error.read
      end
      raise(GPGError, errmsg) unless errmsg.empty?
      res
    end

    # Generates string used to start the gpg  call.
    private def command(*extra)
      cmd = `which gpg2`.strip || `which gpg`.strip
      raise(GPGError, 'gpg not found') unless cmd
      args = ['--no-tty', '--quiet', "--recipient=#{@id}"]
      Shellwords.join([cmd].concat(args, extra))
    end
  end
end
