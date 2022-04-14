from asyncio.subprocess import PIPE

from jbhannah.infrastructure.asyncio.subprocess import run
from jbhannah.infrastructure.helm.manifest import read_manifests
from yaml import Dumper, dump


async def upgrade(cluster: str, namespace: str, name: str, *args):
    """Install or upgrade a Helm deployment, given a manifest containing the
    target cluster, namespace, installation name, chart name, repo, and version,
    and values."""
    async for manifest in read_manifests(cluster, namespace, name):
        flags = {
            "namespace": manifest["metadata"]["namespace"],
            "values": "-",
            **{
                key: manifest["spec"]["chart"][key]
                for key in ["repo", "version"]
            }
        }
        args = [
            "upgrade", manifest["metadata"]["name"],
            manifest["spec"]["chart"]["name"], "--install", *[
                "--{key}={value}".format(key=key, value=flags[key])
                for key in flags
            ], *args
        ]

        values = dump(manifest["spec"]["values"], Dumper=Dumper).encode()

        _, done = await run(
            "helm",
            *args,
            stdin=PIPE,
            callback=lambda proc, values=values: proc.communicate(values))
        await done
