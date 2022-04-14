from click import Context, pass_context, version_option
from jbhannah.infrastructure import __name__ as package_name
from jbhannah.infrastructure import logger
from jbhannah.infrastructure.click import group, verbose_option

from .bootstrap import bootstrap
from .hello import hello
from .helm import helm
from .playbook import playbook
from .terraform import terraform


@group()
@verbose_option(logger)
@version_option(package_name=package_name)
@pass_context
def inf(ctx: Context):
    ctx.ensure_object(dict)


inf.add_command(hello)
inf.add_command(bootstrap)

inf.add_command(playbook)
inf.add_command(playbook, name="pb")

inf.add_command(terraform)
inf.add_command(terraform, name="tf")

inf.add_command(helm)
