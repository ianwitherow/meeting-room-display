module ApplicationHelper
  def seconds_to_px(seconds)
    calendar_start_hour = 8
    hour_height_in_pixels = 50
    calendar_starts_at = calendar_start_hour * hour_height_in_pixels

    seconds.to_f / 3600 * hour_height_in_pixels - calendar_starts_at
  end
end
