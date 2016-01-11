module AngledDeck
  class Client
    attr_reader :config
    attr_reader :endpoint

    def initialize(endpoint:, config:)
      @endpoint = endpoint
      @config = config
    end

    def project
      config[:project]
    end

    def endpoint
      config[:endpoint] || "https://adeck.com"
    end

    def file_key(file)
      (Pathname(config[:s3][:prefix] || "") + SecureRandom.hex(10)).to_s
    end

    def upload(file:)
      s3 = Aws::S3::Client.new(region: config[:s3][:region])
      key = file_key(file)

      bucket = Aws::S3::Bucket.new(config[:s3][:bucket], client: s3)

      object = file.open do |io|
        bucket.put_object(
          key: key,
          body: io,
        )
      end

      object.public_url
    end

    def project_builds_url
      endpoint + "/api/projects/#{project}/builds"
    end

    def build_object(topic, name, version, identifier, url)
      b = {
        name: name,
        bundle_version: version,
        bundle_identifier: identifier,
        url: url
      }

      if topic
        {
          topic_url: topic,
          build: b
        }
      else
        { build: b }
      end
    end

    def add_build(topic:, name:, version:, identifier:, url:)
      httpclient = HTTPClient.new

      result = httpclient.post(project_builds_url,
                               build_object(topic, name, version, identifier, url).to_json,
                               "Content-Type" => "application/json",
                               "Accept" => ["application/json"])

      if result.status == 200
        JSON.parse(result.body, symbolize_names: true)[:build_url]
      else
        raise "Failed to add build: status=#{result.status}"
      end
    end
  end
end
