from functools import wraps
from logging import DEBUG, Logger

from click import option


def verbose_option(logger: Logger):
    """Add a --verbose/-v flag to a Click command that sets the log level of the
    given logger to DEBUG."""
    def decorator(func):
        @option(
            "--verbose",
            "-v",
            help="Increase logging output.",
            is_flag=True,
            default=False,
        )
        @wraps(func)
        def wrapper(verbose=False, *func_args, **func_kwargs):
            if verbose:
                logger.setLevel(DEBUG)

            return func(*func_args, **func_kwargs)

        return wrapper

    return decorator
