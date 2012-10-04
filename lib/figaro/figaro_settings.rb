class FigaroSettings
  class SettingNotFoundError < StandardError; end

  class << self
    def method_missing(symbol, *args, &block)
      val = nil
      if RUBY_ENGINE == "jruby"
        val = java.lang.System.get_property(symbol.to_s)
      end
      if val.nil? && ENV.key?(symbol.to_s.upcase)
        val = ENV[symbol.to_s.upcase]
      end
      unless val.nil?
        self.class.send(:define_method, symbol) { val }
        send(symbol)
      else
        raise SettingNotFoundError, symbol
      end
    end

    def respond_to?(symbol)
      val = nil
      if RUBY_ENGINE == "jruby"
        val = java.lang.System.get_property(symbol.to_s)
      end
      if val.nil? && ENV.key?(symbol.to_s.upcase)
        val = ENV[symbol.to_s.upcase]
      end
    end
  end
end