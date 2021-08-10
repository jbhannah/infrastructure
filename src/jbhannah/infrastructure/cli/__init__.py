from logging import DEBUG, getLogger

from click import option

from .group import group

logger = getLogger(__name__)


@group()
@option(
    "--verbose",
    "-v",
    is_flag=True,
    default=False,
)
def main(verbose=False):
    if verbose:
        logger.setLevel(DEBUG)


@main.command()
def hello():
    logger.info("Hello, Click!")
    logger.debug("Hello, debug mode!")
