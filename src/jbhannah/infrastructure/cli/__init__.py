from logging import getLogger

from click.core import Context
from click.decorators import pass_context
from jbhannah.infrastructure.click import group, verbose_option

from .adopt import adopt

logger = getLogger(__name__)


@group()
@verbose_option(logger)
@pass_context
def main(ctx: Context):
    ctx.ensure_object(dict)


@main.command()
@verbose_option(logger)
def hello():
    logger.info("Hello, Click!")
    logger.debug("Hello, debug mode!")


main.proxy_command()(adopt)
