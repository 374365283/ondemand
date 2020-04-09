require "dotenv"
require "etc"
require "pathname"
require "socket"

require "ood_portal_generator/version"
require "ood_portal_generator/application"
require "ood_portal_generator/view"
require "ood_portal_generator/dex"

# The main namespace for ood_portal_generator
module OodPortalGenerator
  class << self
    # Root path of this library
    # @return [Pathname] root path of library
    def root
      Pathname.new(__dir__).dirname
    end

    def os_release_file
      path = '/etc/os-release'
      return nil unless File.exist?(path)
      path
    end

    def scl_apache?
      return true if os_release_file.nil?
      env = Dotenv.parse(os_release_file)
      return false if ("#{env['ID']} #{env['ID_LIKE']}" =~ /rhel/ && env['VERSION_ID'] =~ /^8/)
      true
    end

    def fqdn
      Socket.gethostbyname(Socket.gethostname).first
    end

    def dex_user
      Etc.getpwnam('ondemand-dex')
      'ondemand-dex'
    rescue ArgumentError
      Etc.getlogin
    end

    def dex_group
      Etc.getgrnam('ondemand-dex')
      'ondemand-dex'
    rescue ArgumentError
      user = Etc.getlogin
      gid = Etc.getpwnam(user).gid
      Etc.getgrgid(gid).name
    end
  end
end
