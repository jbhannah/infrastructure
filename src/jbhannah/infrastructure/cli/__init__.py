from logging import getLogger

from click import Context, pass_context, version_option
from jbhannah.infrastructure.click import group, verbose_option

from .bootstrap import bootstrap
from .hello import hello
from .playbook import playbook

logger = getLogger(__name__)


@group()
@verbose_option(logger)
@version_option(package_name="jbhannah.infrastructure")
@pass_context
def inf(ctx: Context):
    ctx.ensure_object(dict)


inf.add_command(hello)
inf.add_command(bootstrap)
inf.add_command(playbook)
