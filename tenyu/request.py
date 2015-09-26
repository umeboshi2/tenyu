from pyramid.request import Request
from pyramid.decorator import reify
import transaction

from trumpet.request import AlchemyRequest

class TenyuRequest(AlchemyRequest):
    @reify
    def trfdb(self):
        maker = self.registry.settings['trfdb.sessionmaker']
        session = maker()
        def close_session(request):
            if request.exception is not None:
                transaction.abort()
            else:
                transaction.commit()
            session.close()
        self.add_finished_callback(close_session)
        return session
