class ApiConstraints
  attr_accessor :default, :version
  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end

  def matches?(req)
    default ||
    req.headers['Accept'].include?("application/vnd.marketplace.v#{version}")
  end
end