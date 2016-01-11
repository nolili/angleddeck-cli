module AngledDeck
  class Config
    attr_reader :content

    def initialize(content)
      @content = content
    end

    def print(io)
      io.puts YAML.dump(content.deep_stringify_keys)
    end

    def [](key)
      content[key]
    end

    def self.load(path:)
      self.new(YAML.load(path.read).deep_symbolize_keys)
    end

    def self.default
      self.new({
        endpoint: "https://ad.ubiregi.com",
        project: "48fad99e-2209-4d5c-8e34-608536822535",
        s3: {
          region: "ap-northeast-1",
          bucket: "your-bucket-name",
          prefix: "path/to/your/folder"
        }
      })
    end
  end
end

