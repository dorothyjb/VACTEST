Dir[Rails.root.join('lib/ruby/**/*.rb')].each { |f| require f }

module Rms
  module Config
    class Database
      attr_accessor :filename,
                    :hostname,
                    :hostport,
                    :sid,
                    :username,
                    :password

      def initialize filename
        @filename = filename
      end

      def update hostname, hostport, sid, username, password
        @hostname = hostname
        @hostport = hostport
        @sid = sid
        @username = username
        @password = password
      end

      def read
        raise ArgumentError, "No filename set" if @filename.nil?
        raise ArgumentError, "File does not exist" unless File.exists? @filename

        seed = File.stat(@filename).mtime.to_i
        content = File.read(@filename)

        @hostname, @hostport,
        @sid, @username,
        @password = content.rotate.unscramble64(seed: seed).split('\n')
      end

      def write
        raise ArgumentError, "No filename set" if @filename.nil?

        seed = Time.now
        content = [ @hostname, @hostport, @sid, @username, @password ].join('\n')

        File.open(@filename, 'w') do |f|
          f.write content.scramble64(seed: seed.to_i).rotate
        end

        FileUtils.touch @filename, mtime: seed
      end

      class Config
        PATH = File.join(Rails.root, ".dbcfg-#{Rails.env}").freeze

        attr_reader :config

        def initialize
          @config = ::Rms::Config::Database.new(PATH)
          @config.read
        end
        @@instance = Config.new

        class << self
          def instance
            @@instance
          end

          def username
            self.instance.config.username
          end

          def password
            self.instance.config.password
          end

          def hostname
            self.instance.config.hostname
          end

          def hostport
            self.instance.config.hostport
          end

          def sid
            self.instance.config.sid
          end
        end

        private_class_method :new
      end
    end
  end
end
