from typing import List

from click import Context, argument
from jbhannah.infrastructure import logger
from jbhannah.infrastructure.ansible.playbook import run_playbook
from jbhannah.infrastructure.click import proxy_command, verbose_option


@proxy_command()
@argument("playbook", required=True)
@argument("selectors", nargs=-1)
@verbose_option(logger)
async def playbook(ctx: Context, playbook: str, selectors: List[str]):
    """Execute a playbook against one or more hosts, defaulting to the hosts
    specified in the playbook."""
    await run_playbook(playbook, selectors, *ctx.args)
