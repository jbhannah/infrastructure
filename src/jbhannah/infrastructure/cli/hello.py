from logging import getLogger

from jbhannah.infrastructure.click import command, verbose_option

logger = getLogger(__name__)


@command()
@verbose_option(logger)
def hello():
    logger.info("Hello, Click!")
    logger.debug("Hello, debug mode!")
