from click import Context, argument
from jbhannah.infrastructure import logger
from jbhannah.infrastructure.click.group import proxy_command
from jbhannah.infrastructure.click.verbose import verbose_option
from jbhannah.infrastructure.helm.upgrade import upgrade


@proxy_command()
@argument("cluster", required=True)
@argument("namespace", required=True)
@argument("name", required=True)
@verbose_option(logger)
async def helm(ctx: Context, cluster: str, namespace: str, name: str):
    """Apply a helm.infra.hannahs.family/v1/HelmChart manifest."""
    await upgrade(cluster, namespace, name, *ctx.args)
