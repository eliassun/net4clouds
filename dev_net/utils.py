
import logging

LOG = logging.getLogger(__name__)


def create_file(file_name, content):
    try:
        with open(file_name, 'w') as f:
            f.write(content)
    except IOError as err:
        LOG.exception('Failed to create a file: %s', file_name)
