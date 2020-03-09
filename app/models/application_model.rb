class ApplicationModel
  def initialize(*args)
    args.first&.each do |attr, value|
      try("#{attr}=", value)
    end
  end
end
