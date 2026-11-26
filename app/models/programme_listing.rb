# Sorts and filters the public programme catalogue by the visitor's choices.
# Programmes are few and their cost and duration are free text, so this works
# on loaded records rather than in SQL.
class ProgrammeListing
  SORTS = {
    "price_asc" => "Price: low to high",
    "price_desc" => "Price: high to low",
    "duration" => "Duration: shortest first"
  }.freeze

  DURATIONS = {
    "week" => { label: "Up to 1 week", days: 1..7 },
    "two_weeks" => { label: "8 to 14 days", days: 8..14 },
    "longer" => { label: "15 days or more", days: 15.. }
  }.freeze

  attr_reader :sort, :duration

  def initialize(packages, sort: nil, duration: nil)
    @packages = packages
    @sort = SORTS.key?(sort) ? sort : SORTS.keys.first
    @duration = duration if DURATIONS.key?(duration)
  end

  def programmes
    @programmes ||= filtered_packages.sort_by { |package| sort_key(package) }
  end

  def filtered?
    duration.present?
  end

  def sort_options
    SORTS.map { |value, label| [label, value] }
  end

  def duration_options
    DURATIONS.map { |value, option| [option[:label], value] }
  end

  private

  def filtered_packages
    return @packages.to_a unless filtered?

    day_range = DURATIONS.fetch(duration)[:days]
    @packages.select { |package| package.lasts_within?(day_range) }
  end

  # Programmes without a price or duration go last in every order.
  def sort_key(package)
    price = package.starting_price
    days = package.shortest_duration

    case sort
    when "price_desc" then [price ? -price : Float::INFINITY, package.name]
    when "duration" then [days || Float::INFINITY, price || Float::INFINITY, package.name]
    else [price || Float::INFINITY, package.name]
    end
  end
end
