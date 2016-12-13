module EventHelper
  def event_classes(calendar, event)
    classes = ["meeting"]
    classes << "current" if calendar.current_event == event
    classes << "rejected" if event.rejected
    classes << "overlapping" if event.overlapping?
    classes.join(" ")
  end

  def event_styles(event, previous_event)
    top = seconds_to_px(event.begin_time.seconds_since_midnight)
    height = duration_to_px(event.duration)

    if consecutive_events?(previous_event, event)
      top += 2
      height -= 2
    end

    styles = "top: #{top}px; height: #{height}px;"
    styles << "padding-top: 0; padding-bottom: 0;" if event.duration.to_i == 1800
    styles
  end

  def consecutive_events?(previous_event, event)
    previous_event.present? && event.begin_time == previous_event.end_time
  end

  def duration_to_px(seconds)
    seconds.to_f / 3600 * 50
  end

  def seconds_to_px(seconds)
    seconds.to_f / 3600 * 50 - calendar_starts_at
  end

  def calendar_starts_at
    8 * 50
  end
end
