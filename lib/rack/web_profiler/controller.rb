require "erb"
require "json"

module Rack
  # Controller
  #
  # Generate the views of the WebProfiler.
  class WebProfiler::Controller
    # Initialize
    #
    # @param request [Rack::WebProfiler::Request]
    def initialize(request)
      @request = request
    end

    # List the webprofiler history.
    def index
      @collections = Rack::WebProfiler::Model::CollectionRecord.order(Sequel.desc(:created_at))
                                                            .limit(20)

      erb "panel/index.erb", layout: "panel/layout.erb"
    end

    # Show the webprofiler panel.
    def show(token)
      @collection = Rack::WebProfiler::Model::CollectionRecord[token: token]
      return error404 if @collection.nil?

      @collectors = Rack::WebProfiler.config.collectors.all

      # @todo return json if request.content_type ask json (same for xml?)
      # @example json {} if @request.media_type.include? "json"

      erb "panel/show.erb", layout: "panel/layout.erb"
    end

    # Print the webprofiler toolbar
    def show_toolbar(token)
      @collection = Rack::WebProfiler::Model::CollectionRecord[token: token]
      return erb nil, status: 404 if @collection.nil?

      @collectors = Rack::WebProfiler.config.collectors.all
      # @todo process the callector views
      # @collectors = Rack::WebProfiler::Collector.render_tabs(@record)

      erb "profiler.erb"
    end

    # Clean the webprofiler.
    def delete
      Rack::WebProfiler::Model.clean

      redirect WebProfiler::Router.url_for_profiler
    end

    private

    def redirect(path)
      Rack::Response.new([], 302, {
        "Location" => "#{@request.base_url}#{path}",
      })
    end

    # Render a HTML reponse from an ERB template.
    #
    # @param path [String] Path to the ERB template
    #
    # @return [Rack::Response]
    def erb(path, layout: nil, status: 200)
      content = ""

      unless path.nil?
        templates = [read_template(path)]
        templates << read_template(layout) unless layout.nil?

        content = templates.inject(nil) do |prev, temp|
          _render_erb(temp) { prev }
        end
      end

      Rack::Response.new(content, status, {
        "Content-Type" => "text/html",
      })
    end

    # Render a JSON response from an Array or a Hash.
    #
    # @param data [Array, Hash] Data
    #
    # @return [Rack::Response]
    def json(data = {})
      Rack::Response.new(data.to_json, 200, {
        "Content-Type" => "application/json",
      })
    end

    def error404
      erb "404.erb", layout: "panel/layout.erb", status: 404
    end

    def _render_erb(template)
      ERB.new(template).result(binding)
    end

    def partial(path)
      return "" if path.nil?
      ERB.new(read_template(path)).result(binding)
    end

    def render_collector(path, data)
      @data = data
      return "" if path.nil?
      ERB.new(read_template(path)).result(binding)
    end

    def read_template(template)
      unless template.empty?
        path = ::File.expand_path("../../templates/#{template}", __FILE__)
        return ::File.read(path) if ::File.exist?(path)
      end
      template
    end
  end
end
