class Calendar
  attr_accessor :items
  attr_accessor :location

  def initialize(json)
    @location = json.summary
    @items = json.items.map { |item| Event.new(item) }
  end
end