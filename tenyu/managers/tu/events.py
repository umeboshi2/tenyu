from datetime import datetime, timedelta

import transaction
from sqlalchemy.orm.exc import NoResultFound
from sqlalchemy import desc

from trumpet.models.base import DBSession

from tenyu.models.tu.base import Venue, Audience, EventVenue
from tenyu.models.tu.base import Event, EventType

def serialize_event(event):
    data = dict()
    for key in ['id', 'start_date', 'start_time', 'end_date',
                'end_time', 'title', 'description',
                'originator']:
        value = getattr(event, key)
        if hasattr(value, 'isoformat'):
            value = value.isoformat()
        data[key] = value
    return data


class EventManager(object):
    def __init__(self, session):
        self.session = session

    def query(self):
        return self.session.query(Event)

    def host_query(self, user_id):
        return self.query().filter_by(originator=user_id)

    def venue_query(self, venue_id):
        return self.query().filter_by(venue_id=venue_id)
    
    def get_all_host_events(self, user_id): 
        return self.host_query(user_id).all()
    
    def get_all_venue_events(self, venue_id):
        q = self.venue_query(venue_id)
        return q.all()

    def get(self, id):
        return self.query().get(id)

    def _range_filter(self, query, start, end):
        "start and end are datetime objects"
        query.filter(Event.start_date >= start)
        query.filter(Event.start_date <= end)
        return query

    def _convert_range(self, start, end):
        "start and end are timestamps"
        start = datetime.fromtimestamp(float(start))
        end = datetime.fromtimestamp(float(end))
        return start, end
    
    def ranged_events(self, start, end):
        "start and end are datetime objects"
        q = self.query()
        q = self._range_filter(q, start, end)
        return q.all()
        
    def ranged_events_host(self, user_id, start, end):
        "start and end are datetime objects"
        q = self.host_query(user_id)
        q = self._range_filter(q, start, end)
        return q.all()

    def get_event_days(self, start, end):
        "start and end are datetime objects"
        q = self.query()
        q = self._range_filter(q, start, end)
        q = q.distinct(Event.start_date)
        return q.all()
    
        
    def ranged_events_ts(self, start, end):
        "start and end are timestamps"
        start, end = self._convert_range(start, end)
        return self.ranged_events(start, end)
    
    def ranged_events_host_ts(self, user_id, start, end):
        "start and end are timestamps"
        start, end = self._convert_range(start, end)
        return self.ranged_events_host(user_id, start, end)

    def get_event_days_ts(self, start, end):
        "start and end are timestamps"
        start, end = self._convert_range(start, end)
        return self.get_event_days(start, end)
    
        
    def all_current_events(self):
        start = datetime.now().date()
        q = self.query().filter(Event.start_date >= start)
        return q.all()

    def events_for_day(self, day):
        q = self.query()
        q = q.filter_by(start_date=day).order_by(Event.start_time)
        return q.all()
    
    def _range_filter(self, query, start, end):
        "start and end are datetime objects"
        query.filter(Event.start_date >= start)
        query.filter(Event.start_date <= end)
        return query

        
    
class EventTypeManager(object):
    def __init__(self, session):
        self.session = session

    def query(self):
        return self.session.query(EventType)
    
    
