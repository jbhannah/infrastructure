from logging import getLogger
from typing import List

from click import Context, argument
from jbhannah.infrastructure.ansible.playbook import run_playbook
from jbhannah.infrastructure.click import proxy_command, verbose_option

BOOTSTRAP_ENV = {
    "ANSIBLE_HOST_KEY_CHECKING": "false",
    "ANSIBLE_TRANSPORT": "paramiko"
}

logger = getLogger(__name__)


@proxy_command()
@argument("selectors", nargs=-1, required=True)
@verbose_option(logger)
async def bootstrap(ctx: Context, selector_list: List[str]):
    """Bootstrap one or more remote hosts."""
    logger.debug("Bootstrapping host selectors {selectors}".format(
        selectors=", ".join(selector_list)))
    await run_playbook("bootstrap",
                       selector_list,
                       *ctx.args,
                       env=BOOTSTRAP_ENV)
