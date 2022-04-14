from pathlib import Path
from typing import Dict

from aiofiles import open as aio_open
from yaml import Loader, load_all

MANIFEST_FILTER = {
    "apiVersion": "helm.infra.hannahs.family/v1",
    "kind": "HelmChart"
}


async def read_manifests(cluster: str, namespace: str, name: str):
    """Read helm.infra.hannahs.family/v1/HelmChart manifests from a file."""
    manifest_path = Path.cwd().joinpath(
        "k8s", cluster, namespace, "{name}.yaml".format(name=name)).resolve()

    async with aio_open(manifest_path) as file:
        contents = await file.read()

    docs = load_all(contents, Loader=Loader)
    manifests = filter(_is_manifest, docs)

    for manifest in manifests:
        yield manifest


def _is_manifest(doc: Dict):
    """Test a document against the filter criteria."""
    return MANIFEST_FILTER == {key: doc[key] for key in MANIFEST_FILTER}
