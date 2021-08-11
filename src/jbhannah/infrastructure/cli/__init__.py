from logging import getLogger

from click.core import Context
from click.decorators import pass_context

from .adopt import adopt
from .group import group

logger = getLogger(__name__)


@group()
@pass_context
def main(ctx: Context):
    ctx.ensure_object(dict)


@main.command()
def hello():
    logger.info("Hello, Click!")
    logger.debug("Hello, debug mode!")


main.proxy_command()(adopt)
