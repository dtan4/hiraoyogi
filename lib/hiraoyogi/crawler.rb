require "nokogiri"
require "open-uri"
require "uri"
require "cgi"

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
        next unless link.attr("href")

        link_url = absolute_url(url, CGI.unescape(link.attr("href")))

        next if @url_list.include?(link_url)
        next unless inner_page?(link_url, domain) && static_page?(link_url)

        @url_list << link_url
        sleep 0.1
        do_crawl(link_url, domain)
      end
    rescue OpenURI::HTTPError
      @url_list.delete(url)
    end

    def url_domain(url)
      URI.parse(url).host
    end

    def absolute_url(root_url, path)
      url = expand_url(root_url, path)
      url = remove_section(url)
      (url[-1] == "/") ? "#{url}index.html" : url
    end

    def expand_url(root_url, path)
      if %r{\Ahttps?://} =~ path
        path
      else
        URI.join(root_url, path).to_s
      end
    end

    def remove_section(url)
      url.sub(/#.*\z/, "")
    end

    def inner_page?(url, domain)
      %r{\Ahttps?://#{domain}} =~ url
    end

    def static_page?(url)
      /\.html?\z/ =~ uri_name(url)
    end

    def uri_name(url)
      File.basename(URI.parse(url).path)
    end
  end
end
