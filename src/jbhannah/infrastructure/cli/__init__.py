from logging import DEBUG, getLogger

from click import option
from click.core import Context
from click.decorators import pass_context
from jbhannah.infrastructure import logger as base_logger

from .adopt import adopt
from .group import group

logger = getLogger(__name__)


@group()
@option(
    "--verbose",
    "-v",
    is_flag=True,
    default=False,
)
@pass_context
def main(ctx: Context, verbose=False):
    if verbose:
        base_logger.setLevel(DEBUG)

    ctx.ensure_object(dict)


@main.command()
def hello():
    logger.info("Hello, Click!")
    logger.debug("Hello, debug mode!")


main.proxy_command()(adopt)
