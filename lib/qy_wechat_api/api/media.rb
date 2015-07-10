# encoding: utf-8

module QyWechatApi
  module Api
    class Media < Base

      # 媒体文件类型，分别有图片（image）、语音（voice）、视频（video），普通文件(file)
      # media: 支持传路径或者文件实例
      def upload(media, media_type)
        file = process_file(media)
        http_post("upload", {media: file}, {type: media_type})
      end

      # 返回一个URL，请开发者自行使用此url下载
      def get_media_by_id(media_id)
        "#{ENDPOINT_URL}#{base_url}/get?access_token=#{access_token}&media_id=#{media_id}"
      end

      private

        def base_url
          "/media"
        end

        def process_file(media)
          return media if media.is_a?(File) && jpep?(media)

          media_url = media
          uploader  = QyWechatApiUploader.new

          if http?(media_url) # remote
            uploader.download!(media_url.to_s)
          else # local
            media_file = media.is_a?(File) ? media : File.new(media_url)
            uploader.cache!(media_file)
          end
          file = process_media(uploader)
          CarrierWave.clean_cached_files! # clear last one day cache
          file
        end

        def process_media(uploader)
          uploader = covert(uploader)
          uploader.file.to_file
        end

        # JUST ONLY FOR JPG IMAGE
        def covert(uploader)
          # image process
          unless (uploader.file.content_type =~ /image/).nil?
            if !jpep?(uploader.file)
              require "mini_magick"
              # covert to jpeg
              image = MiniMagick::Image.open(uploader.path)
              image.format("jpg")
              uploader.cache!(File.open(image.path))
              image.destroy! # remove /tmp from MinMagick generate
            end
          end
          uploader
        end

        def http?(uri)
          return false if !uri.is_a?(String)
          uri = URI.parse(uri)
          uri.scheme =~ /^https?$/
        end

        def jpep?(file)
          content_type = if file.respond_to?(:content_type)
              file.content_type
            else
              content_type(file.path)
            end
          !(content_type =~ /jpeg/).nil?
        end

        def content_type(media_path)
          MIME::Types.type_for(media_path).first.content_type
        end
    end
  end
end
