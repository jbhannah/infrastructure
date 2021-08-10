from logging import DEBUG, getLogger

import click

logger = getLogger(__name__)


@click.command()
@click.option(
    "--verbose",
    "-v",
    is_flag=True,
    default=False,
)
def main(verbose=False):
    if verbose:
        logger.setLevel(DEBUG)

    logger.info("Hello, Click!")
    logger.debug("Hello, debug mode!")
