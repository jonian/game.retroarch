import os
import re

from zipfile import ZipFile

ROOT_PATH = os.path.dirname(os.path.abspath(__file__))
DATA_PATH = os.path.join(ROOT_PATH, 'addon.xml')
PKGS_PATH = os.path.join(ROOT_PATH, 'package')

SKIP_DIRS = ['package', 'build', 'retroarch', 'libretro']
SKIP_FILE = ['package.py']
SKIP_NAME = ['__pycache__']


if not os.path.exists(PKGS_PATH):
  os.makedirs(PKGS_PATH)

with open(DATA_PATH, 'r') as file:
  data = re.search(r'<addon (.*?)>', file.read()).group(1)
  data = dict(re.findall(r'([\w-]+)="(.*?)"', data))

arcpath = os.path.join(PKGS_PATH, '{id}-{version}.zip'.format(**data))

with ZipFile(arcpath, 'w') as zipf:
  for root, dirs, files in os.walk(ROOT_PATH):

    for dir in dirs[:]:
      dirpath = os.path.join(root, dir)
      dirname = os.path.relpath(dirpath, ROOT_PATH)

      if dirname.startswith('.') or dir in SKIP_NAME or dirname in SKIP_DIRS:
        dirs.remove(dir)

    for file in files:
      filepath = os.path.join(root, file)
      filename = os.path.relpath(filepath, ROOT_PATH)

      if filename.startswith('.') or file in SKIP_NAME or filename in SKIP_FILE:
        continue

      arcname = os.path.join(data['id'], filename)
      zipf.write(filepath, arcname=arcname)
