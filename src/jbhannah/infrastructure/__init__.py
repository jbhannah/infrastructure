from logging import INFO, StreamHandler, getLogger
from sys import stderr

logger = getLogger(__name__)
logger.setLevel(INFO)

handler = StreamHandler(stream=stderr)
logger.addHandler(handler)


class Exception(Exception):
    """Specific exception for handling only internal errors."""
    def __init__(self, *args):
        super().__init__(*args)
        self.returncode = 1
