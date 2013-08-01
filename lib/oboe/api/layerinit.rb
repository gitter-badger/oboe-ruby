module Oboe
  module API
    module LayerInit
      # Internal: Report that instrumentation for the given layer has been
      # installed, as well as the version of instrumentation and version of
      # layer.
      #
      def report_init(layer)
        platform_info = { '__Init' => 1 }
        
        begin
          platform_info['Force']                 = true
          platform_info['RubyPlatformVersion']   = RUBY_PLATFORM
          platform_info['RubyVersion']           = RUBY_VERSION
          platform_info['RailsVersion']          = ::Rails.version if defined?(Rails)
          platform_info['OboeRubyVersion']       = Oboe::Version::STRING
          platform_info['OboeHerokuRubyVersion'] = OboeHeroku::Version::STRING if defined?(OboeHeroku)
        rescue
        end

        start_trace(layer, nil, platform_info) { }
      end

      ##
      # force_trace has been deprecated and will be removed in a subsequent version.
      #
      def force_trace
        Oboe.logger.warn "Oboe::API::LayerInit.force_trace has been deprecated and will be removed in a subsequent version."

        saved_mode = Oboe::Config[:tracing_mode]
        Oboe::Config[:tracing_mode] = 'always'
        yield
      ensure
        Oboe::Config[:tracing_mode] = saved_mode
      end
    end
  end
end
