class Calendar extends React.Component {
  constructor(props) {
    super(props);

    this.events = [];
    this.loadCalendarEvents();
  }

  loadCalendarEvents() {
    axios.get("/api/calendars/" + this.props.calendarId)
      .then((result) => {
        this.events = result.data.events;
        this.forceUpdate();
      });
  }

  render () {
    return (
      <div className='events'>
        {this.events.map((e) =>
          <Event key={e.key} event={e}>
          </Event>
        )}
      </div>
    );
  }
}

Calendar.propTypes = {
  calendarId: React.PropTypes.string
};

