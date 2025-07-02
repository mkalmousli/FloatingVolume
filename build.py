#!/usr/bin/env python3
"""
This script is meant to make building APK reproducible on different environments.
Mainly, to produce the same APK on F-Droid server and on local machine using Docker.
"""
from os import environ, listdir, makedirs, remove, walk
from os.path import abspath, dirname, join, exists, basename, getsize, isdir, isfile
from argparse import ArgumentParser
from os import makedirs
from shutil import copy, copytree, move, rmtree
from typing import List
from subprocess import check_call, Popen, PIPE
from json import load
from urllib.request import Request, urlopen
from enum import Enum


class Environment(Enum):
    FDROID = "fdroid"
    DOCKER = "docker"




THIS_FILE = abspath(__file__)
THIS_DIR = dirname(THIS_FILE)
ROOT_DIR = THIS_DIR

print(f"THIS_FILE: {THIS_FILE}")
print(f"THIS_DIR: {THIS_DIR}")
print(f"ROOT_DIR: {ROOT_DIR}")



with open(join(ROOT_DIR, '.fvmrc'), 'r') as f:
    fvmrc = load(f)
    FLUTTER_VERSION = fvmrc.get('flutter')

print(f"FLUTTER_VERSION: {FLUTTER_VERSION}")





def mk(dir: str):
    makedirs(dir, exist_ok=True)

def mkp(entity: str):
    mk(dirname(entity))

def human_size(n):
    for unit in ['B', 'KB', 'MB', 'GB', 'TB']:
        if n < 1024:
            return f"{n:.1f} {unit}"
        n /= 1024
    return f"{n:.1f} PB"

def download(url: str, id: str | None = None) -> str:
    if id is None:
        id = basename(url)
    
    f_full = join(FULL_DOWNLOADS_DIR, id)
    f_part = join(PART_DOWNLOADS_DIR, id)
    if exists(f_full):
        return f_full

    is_resume = exists(f_part)
    mkp(f_part)


    headers = {}
    mode = 'wb'
    downloaded = 0

    if is_resume:
        downloaded = getsize(f_part)
        headers['Range'] = f'bytes={downloaded}-'
        mode = 'ab'

    req = Request(url, headers=headers)
    with urlopen(req) as response, open(f_part, mode) as out_file:
        total_size = int(response.headers.get('Content-Length', 0))
        if 'Content-Range' in response.headers:
            total_size += downloaded
        block_size = 8192
        count = downloaded // block_size
        while True:
            buffer = response.read(block_size)
            if not buffer:
                break
            out_file.write(buffer)
            count += 1
            current = downloaded + count * block_size
            percent = min(100, int(current * 100 / total_size)) if total_size else 0
            # ANSI color: green for <50%, yellow for <90%, red otherwise
            if percent < 50:
                color = '\033[91m'  # red
            elif percent < 90:
                color = '\033[93m'  # yellow
            else:
                color = '\033[92m'  # green
            reset = '\033[0m'
            print(
                f"Downloading {id}: {color}{percent:3d}%{reset} "
                f"({human_size(min(current, total_size))}/{human_size(total_size)})",
                end='\r'
            )

    from shutil import move
    mkp(f_full)
    move(f_part, f_full)
    print()  # Newline after progress
    return f_full



def new_temp_path(
    dir: str | None = None,
    prefix: str | None = None,
    suffix: str | None = None
) -> str:
    dir = dir or TEMP_DIR
    prefix = prefix or ''
    suffix = suffix or ''

    i = 0
    while True:
        path = join(
            dir,
            f"{prefix}{i}{suffix}"
        )

        if not exists(path):
            return path
        
        i += 1

def new_temp_dir(
    dir: str | None = None,
    prefix: str | None = None,
    suffix: str | None = None
) -> str:
    path = new_temp_path(
        dir=dir,
        prefix=prefix,
        suffix=suffix
    )
    mk(path)
    return path

def new_temp_file(
    dir: str | None = None,
    prefix: str | None = None,
    suffix: str | None = None
) -> str:
    path = new_temp_path(
        dir=dir,
        prefix=prefix,
        suffix=suffix
    )
    mkp(path)
    with open(path, 'w') as f:
        pass  # Create an empty file
    return path




def extract(f_archive: str, d_dest: str):
    if exists(d_dest):
        return

    d_temp = new_temp_dir(suffix='_extract')

    file_name = basename(f_archive)
    if file_name.endswith(".tar") or file_name.endswith(".tar.gz"):
        check_call(['tar', '-xzf', f_archive], cwd=d_temp)
    elif file_name.endswith(".zip"):
        check_call(['unzip', f_archive], cwd=d_temp)
    else:
        raise ValueError(f"Unsupported archive format: {file_name}")
    

    first_entity: str | None = None
    is_single_entity = True
    for entity in listdir(d_temp):
        if first_entity is None:
            first_entity = join(d_temp, entity)
        else:
            is_single_entity = False
            break

    mkp(d_dest)

    if is_single_entity:
        if isdir(first_entity):
            move(first_entity, d_dest)
            rmtree(d_temp)
        elif isfile(first_entity):
            move(d_temp, d_dest)
    else:
        move(d_temp, d_dest)







"""
This path is fix, to make sure the build is reproducible.
"""
REPRODUCIBLE_ROOT_DIR = "/app"  # Reproducible root directory




CACHE_DIR = join(REPRODUCIBLE_ROOT_DIR, '.CACHE')
DOWNLOADS_DIR = join(CACHE_DIR, 'Downloads')
FULL_DOWNLOADS_DIR = join(DOWNLOADS_DIR, 'Full')
PART_DOWNLOADS_DIR = join(DOWNLOADS_DIR, 'Part')
TOOLS_DIR = join(CACHE_DIR, 'Tools')
TEMP_DIR = join(CACHE_DIR, 'Temp')
PUBCACHE_DIR = join(CACHE_DIR, 'PubCache')



"""
Determine the build environment based on the directory.
"""
if ROOT_DIR == REPRODUCIBLE_ROOT_DIR:
    BUILD_ENV = Environment.DOCKER
else:
    BUILD_ENV = Environment.FDROID

print(f"BUILD_ENV: {BUILD_ENV.value}")


if BUILD_ENV == Environment.FDROID:
    mkp(REPRODUCIBLE_ROOT_DIR)
    
    mkp(REPRODUCIBLE_ROOT_DIR)
    copytree(
        ROOT_DIR,
        REPRODUCIBLE_ROOT_DIR
    )



print("BUILD ENVIRONMENT:", BUILD_ENV.value)

if BUILD_ENV == Environment.DOCKER:
    d_java_home = "/usr/lib/jvm/java-17-openjdk-amd64"
    print(f"JAVA_HOME: {d_java_home}")
    environ['JAVA_HOME'] = d_java_home





if BUILD_ENV == Environment.FDROID:
    ANDROID_HOME = "/opt/android-sdk"

    if exists(ANDROID_HOME):
        print("Using F-Droid's Android SDK at:", ANDROID_HOME)
    else:
        raise FileNotFoundError("F-Droid server requires Android SDK to be at /opt/android-sdk.")

else:
    ANDROID_HOME = join(TOOLS_DIR, 'AndroidSDK')

    if not exists(ANDROID_HOME):
        f_archive = download("https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip")
        d_cmdtools = join(TOOLS_DIR, 'CommandLineTools')
        extract(f_archive, d_cmdtools)

        yes_process = Popen(["yes"], stdout=PIPE)
        sdk_process = check_call(
            [
                join(d_cmdtools, 'bin', 'sdkmanager'), 
                '--sdk_root=' + ANDROID_HOME,
                "--licenses"
            ],
            stdin=yes_process.stdout,
        )

        check_call([
            join(d_cmdtools, 'bin', 'sdkmanager'),
            '--sdk_root=' + ANDROID_HOME,
            'platform-tools',
            'build-tools;30.0.3'
        ])

        print("Android SDK installed successfully.")
    
    else:
        print("Android SDK already exists at:", ANDROID_HOME)


environ['ANDROID_HOME'] = ANDROID_HOME
print(f"ANDROID_HOME: {ANDROID_HOME}")






d_flutter = join(TOOLS_DIR, 'Flutter')

if exists(d_flutter):
    print(f"Flutter SDK ({FLUTTER_VERSION}) already exists at {d_flutter}.")
else:
    print(f"Downloading Flutter SDK ({FLUTTER_VERSION})...")

    mkp(d_flutter)
    check_call([
        "git", "clone", "--depth", "1", "--branch", FLUTTER_VERSION,
        "https://github.com/flutter/flutter.git", d_flutter
    ])

    print(f"Flutter SDK ({FLUTTER_VERSION}) downloaded to {d_flutter}.")


environ['PATH'] = f"{join(d_flutter, 'bin')}:{environ.get('PATH', '')}"
environ['PUB_CACHE'] = PUBCACHE_DIR

print(f"FLUTTER SDK PATH: {join(d_flutter, 'bin')}")
print(f"PUB_CACHE: {PUBCACHE_DIR}")


def run_flutter(cmd: List[str], env: dict = None):
    """Run a Flutter command with the given environment."""
    env = environ.copy()
    check_call(
        ["flutter"] + cmd,
        env=env,
        cwd=REPRODUCIBLE_ROOT_DIR
    )

run_flutter([
    "config", "--no-analytics"
])

run_flutter([
    'config', '--no-analytics'
])

run_flutter([
    "pub", "get"
])

run_flutter([
    "build", "apk", "--release", "--verbose",
])

f_apk = join(ROOT_DIR, "app.apk")
if exists(f_apk):
    print("Removing old APK:", f_apk)
    remove(f_apk)

copy(
    join(REPRODUCIBLE_ROOT_DIR, 'build', 'app', 'outputs', 'flutter-apk', 'app-release.apk'),
    f_apk
)
print("APK built successfully:", f_apk)
