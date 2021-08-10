from logging import INFO, StreamHandler, getLogger
from sys import stderr

logger = getLogger(__name__)
logger.setLevel(INFO)

handler = StreamHandler(stream=stderr)
logger.addHandler(handler)
