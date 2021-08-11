from logging import getLogger

from click import Context, pass_context, version_option
from jbhannah.infrastructure.click import group, verbose_option

from .adopt import adopt
from .hello import hello

logger = getLogger(__name__)


@group()
@verbose_option(logger)
@version_option(package_name="jbhannah.infrastructure")
@pass_context
def main(ctx: Context):
    ctx.ensure_object(dict)


main.add_command(hello)
main.add_command(adopt)
