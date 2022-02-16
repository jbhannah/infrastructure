from click import Context
from jbhannah.infrastructure import logger
from jbhannah.infrastructure.click import proxy_command, verbose_option
from jbhannah.infrastructure.terraform.command import run_command


@proxy_command()
@verbose_option(logger)
async def terraform(ctx: Context):
    """Run the terraform command with the provided arguments."""
    await run_command(*ctx.args)
