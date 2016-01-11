require "thor"

module AngledDeck
  class CLI < Thor
    class Build < Thor
      desc "add name identifier version file", "add new build"
      option :topic, type: :string
      def add(name, identifier, version, file)
        path = Pathname(options[:config])
        unless path.file?
          STDOUT.puts "Config file not found: #{path}"
          STDOUT.puts "Try `adeck config generate` to scaffold configuration"
          exit
        end
        config = AngledDeck::Config.load(path: path)
        client = Client.new(endpoint: options[:endpoint], config: config)
        STDOUT.puts "Uploading file..."
        url = client.upload(file: Pathname(file))
        STDOUT.puts "  > Uploaded to #{url}"
        STDOUT.puts "Adding new build..."
        build_url = client.add_build(topic: options[:topic], name: name, version: version, identifier: identifier, url: url)
        STDOUT.puts "  > Done: your new build is available at #{build_url}"
      rescue => exn
        STDOUT.puts "ERROR: #{exn}"
      end
    end

    class Config < Thor
      desc "generate", "Make sample config file"
      def generate
        path = Pathname(options[:config])
        if path.file?
          STDOUT.puts "Config file already exists: #{path}"
          return
        end

        path.open "w" do |io|
          AngledDeck::Config.default.print(io)
        end

        STDOUT.puts "Generated #{path} with default configuration"

        print
      end

      desc "print", "Print configuration loaded from config file"
      def print
        path = Pathname(options[:config])
        unless path.file?
          STDOUT.puts "Config file not found: #{path}"
          STDOUT.puts "Try `adeck config generate` to scaffold configuration"
          return
        end

        config = AngledDeck::Config.load(path: path)
        config.print(STDOUT)
      end
    end

    class_option :config, type: :string, default: "adeck.yml"

    desc "config SUBCOMMAND ...ARGS", "Manage configuration"
    subcommand "config", Config

    desc "build SUBCOMMAND ...ARGS", "Manage build"
    subcommand "build", Build
  end
end
