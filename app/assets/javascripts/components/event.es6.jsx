class Event extends React.Component {
  constructor(props) {
    super(props);

    this.calendarStartHour = 8;
    this.hourHeightInPixels = 50;

    this.calendarStartsAtPixel = this.calendarStartHour * this.hourHeightInPixels;
    this.styles = {
      top: this.calculateTop(),
      height: this.calculateHeight(),
      paddingTop: this.calculatePaddingTop()
    };
  }

  render () {
    return (
      <div className={this.className()} style={this.styles}>
        {this.props.event.begin_time} - {this.props.event.end_time} | {this.props.event.summary}
      </div>
    );
  }

  className() {
    var classNames = ['meeting']
    if (this.props.event.is_rejected) { classNames.push('rejected') }
    if (this.props.event.is_overlapping) { classNames.push('overlapping') }
    return classNames.join(' ')
  }

  calculateTop() {
    pixels = this.props.event.seconds_after_midnight / 3600 * this.hourHeightInPixels - this.calendarStartsAtPixel

    if (this.props.event.is_consecutive) { pixels += 2 }

    return pixels + 'px'
  }

  calculateHeight() {
    duration = this.props.event.duration;
    pixels = duration / 3600 * this.hourHeightInPixels

    if (this.props.event.is_consecutive) { pixels -= 2 }

    return pixels + 'px'
  }

  calculatePaddingTop() {
    if (this.props.event.duration == 1800) {
      return 2;
    } else {
      return null
    }
  }
}

Event.propTypes = {
  event: React.PropTypes.object
};

