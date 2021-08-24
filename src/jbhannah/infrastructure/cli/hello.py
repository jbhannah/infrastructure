from jbhannah.infrastructure import logger
from jbhannah.infrastructure.click import command, verbose_option


@command()
@verbose_option(logger)
def hello():
    logger.info("Hello, Click!")
    logger.debug("Hello, debug mode!")
