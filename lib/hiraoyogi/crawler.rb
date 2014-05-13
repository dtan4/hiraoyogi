require "nokogiri"
require "open-uri"
require "uri"

module Hiraoyogi
  class Crawler
    attr_reader :url_list

    def initialize
      @url_list = []
    end

    def crawl(root_url)
      url = root_url[-1] == "/" ? "#{root_url}index.html" : "#{root_url}/index.html"
      @url_list << url
      do_crawl(url, url_domain(url))
    end

    private

    def do_crawl(url, domain)
      doc = Nokogiri::HTML.parse(open(url).read)

      doc.css("a").each do |link|
        link_url = absolute_url(url, link.attr("href"))

        next if @url_list.include?(link_url)
        next unless static_page?(link_url)

        if inner_page?(link_url, domain)
          @url_list << link_url
          do_crawl(link_url, domain)
        end
      end
    end

    def url_domain(url)
      URI.parse(url).host
    end

    def absolute_url(root_url, path)
      url = expand_url(root_url, path)
      (url[-1] == "/") ?  "#{url}index.html" : url
    end

    def expand_url(root_url, path)
      if %r{\Ahttps?://} =~ path
        path
      else
        URI.join(root_url, path).to_s
      end
    end

    def inner_page?(url, domain)
      %r{\Ahttps?://#{domain}} =~ url
    end

    def static_page?(url)
      /\.html?$/ =~ File.extname(uri_name(url))
    end

    def uri_name(url)
      if url[-1] == "/"
        "index.html"
      else
        File.basename(URI.parse(url).path)
      end
    end
  end
end
