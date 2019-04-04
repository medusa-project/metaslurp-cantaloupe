##
# This file is for Cantaloupe 4.1 release.
#

require 'json'

java_import java.net.HttpURLConnection
java_import java.net.URL
java_import java.io.BufferedReader
java_import java.io.FileNotFoundException
java_import java.io.InputStreamReader
java_import java.util.Base64
java_import java.util.stream.Collectors

class CustomDelegate

  attr_accessor :context

  def authorize(options = {})
    true
  end

  def extra_iiif2_information_response_keys(options = {})
    {}
  end

  ##
  # Identifiers should all be prefixed with a content service key, which tells
  # us where to find them.
  #
  def source(options = {})
    parts = context['identifier'].split('-')
    case parts[0]
    when 'dls'
      return 'S3Source'
    else
      return 'HttpSource'
    end
  end

  def azurestoragesource_blob_key(options = {})
  end

  def filesystemsource_pathname(options = {})
  end

  ##
  # Used for serving IDNC images.
  #
  def httpsource_resource_info(options = {})
    image = master_image
    if image and image['uri'].start_with?('http')
      return image['uri']
    end
    nil
  end

  def jdbcsource_database_identifier(options = {})
  end

  def jdbcsource_media_type(options = {})
  end

  def jdbcsource_lookup_sql(options = {})
  end

  ##
  # Used for serving DLS images.
  #
  def s3source_object_info(options = {})
    image = master_image
    if image and image['uri'].start_with?('s3://')
      groups = image['uri'].scan(/[^\/]+/)
      return {
        'bucket' => groups[1],
        'key' => groups[2..999].join('/')
      }
    end
  end

  def overlay(options = {})
  end

  def redactions(options = {})
    []
  end

  private

  ##
  # @return [Hash]
  #
  def master_image
    identifier = context['identifier']

    url = URL.new(sprintf('%s/it/%s.json',
        ENV['METASLURP_URL'],
        URI.escape(identifier)))

    conn, is, reader = nil
    begin
      conn = url.openConnection
      conn.setRequestMethod 'GET'
      conn.setReadTimeout 30 * 1000
      conn.connect
      is = conn.getInputStream
      status = conn.getResponseCode

      if status == 200
        reader = BufferedReader.new(InputStreamReader.new(is))
        entity = reader.lines.collect(Collectors.joining("\n"))
        struct = JSON.parse(entity)
        return struct['images'].find { |im| im['master'] }
      else
        raise IOError, "Unexpected response status: #{status}"
      end
    rescue FileNotFoundException => e
      return nil
    rescue => e
      Java::edu.illinois.library.cantaloupe.script.Logger
          .warn('CustomDelegate.master_image: {}', e.message, e)
    ensure
      reader&.close
      is&.close
      conn&.disconnect
    end
  end

end
