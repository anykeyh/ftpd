#!/usr/bin/env ruby

module Ftpd
  class FtpServer < TlsServer

    # If truthy, emit debug information (such as replies received and
    # responses sent) to the file named by #debug_path.
    #
    # Change to this attribute only take effect for new sessions.

    attr_accessor :debug

    # The path to which to write debug information.  Defaults to
    # '/dev/stdout'
    #
    # Change to this attribute only take effect for new sessions.

    attr_accessor :debug_path

    # The number of seconds to delay before replying.  This is for
    # testing, when you need to test, for example, client timeouts.
    # Defaults to 0 (no delay).
    #
    # Change to this attribute only take effect for new sessions.

    attr_accessor :response_delay

    # The class for formatting for LIST output.  Defaults to
    # {Ftpd::ListFormat::Ls}.  Changes to this attribute only take
    # effect for new sessions.

    attr_accessor :list_formatter

    # @return [Integer] The authentication level
    # One of:
    # * Ftpd::AUTH_USER
    # * Ftpd::AUTH_PASSWORD (default)
    # * Ftpd::AUTH_ACCOUNT

    attr_accessor :auth_level

    # Create a new FTP server.  The server won't start until the
    # #start method is called.
    #
    # @param driver A driver for the server's dynamic behavior such as
    #               authentication and file system access.
    #
    # The driver should expose these public methods:
    # * {Example::Driver#authenticate authenticate}
    # * {Example::Driver#file_system file_system}

    def initialize(driver)
      super()
      @driver = driver
      @debug_path = '/dev/stdout'
      @debug = false
      @response_delay = 0
      @list_formatter = ListFormat::Ls
      @auth_level = AUTH_PASSWORD
    end

    private

    def session(socket)
      Session.new(:socket => socket,
                  :driver => @driver,
                  :debug => @debug,
                  :debug_path => debug_path,
                  :list_formatter => @list_formatter,
                  :response_delay => response_delay,
                  :tls => @tls,
                  :auth_level => @auth_level).run
    end

  end
end
