# The Vitis workspace sw/vitis/ with the Vitis Python API (Vitis Unified,
# from 2023.2; tested with 2025.1). The calls are the ones the GUI records in
# _ide/workspace_journal.py. Run by sw/scripts/vitis.sh, from work/, with:
#   vitis -s vitis-unified.py
# and two environment variables, because the arguments after the script are
# not documented:
#   VITIS_ROOT  root of the product
#   VITIS_MODE  update  repair what is missing, without building:
#                       - a platform whose copy of the .xsa is missing (it is
#                         not committed) or differs from sw/hw/ (after
#                         'make xsa'): update its hardware, and delete _ide/
#                         of its applications, which would otherwise keep the
#                         old bitstream;
#                       - BSPs without their sources (they are not
#                         committed): regenerate them;
#               build   the same, then build platforms and applications,
#                       check that the expected files exist, and write
#                       out/vitis/BOOT.bin with bootgen: FSBL, bitstream and
#                       the application in VITIS_BOOT_APP of sw/config.sh
#                       (or the only application of the workspace).
# The GUI must be closed, because it locks the workspace: vitis.sh checks it.
# The output of the Vitis tools is long: the progress lines of this script go
# to stderr and start with "vitis:", so that vitis.sh can send the rest to
# work/vitis.log.

import filecmp
import glob
import json
import os
import shutil
import subprocess
import sys
import zipfile

import vitis


def step(text):
    print("vitis: " + text, file=sys.stderr, flush=True)


def fail(text):
    print("vitis: ERROR: " + text, file=sys.stderr, flush=True)
    vitis.dispose()
    sys.exit(1)


def read_component(path):
    with open(path) as f:
        return json.load(f)


# Directory of the BSP of a domain, where Vitis Unified creates it.
def bsp_dir(platform_dir, domain):
    if domain["isBootDomain"]:
        return os.path.join(platform_dir, "zynq_fsbl", "zynq_fsbl_bsp")
    return os.path.join(platform_dir, domain["processor"], domain["name"], "bsp")


root = os.environ["VITIS_ROOT"]
mode = os.environ["VITIS_MODE"]
boot_app = os.environ.get("VITIS_BOOT_APP", "")
if mode not in ("update", "build"):
    print("vitis: ERROR: VITIS_MODE must be update or build", file=sys.stderr)
    sys.exit(1)
ws = os.path.join(root, "sw", "vitis")

# Components: a vitis-comp.json in each directory of the workspace.
platforms = {}
apps = {}
for path in sorted(glob.glob(os.path.join(ws, "*", "vitis-comp.json"))):
    component = read_component(path)
    if component["type"] == "PLATFORM":
        platforms[component["name"]] = component
    elif component["type"] == "HOST":
        apps[component["name"]] = component
if not platforms:
    step("no platform in " + ws + " yet: nothing to do, create one in the Vitis GUI")
    sys.exit(0)

# The hardware comes only from sw/hw/, the .xsa delivered by 'make update-xsa'.
found = glob.glob(os.path.join(root, "sw", "hw", "*.xsa"))
if len(found) != 1:
    print("vitis: ERROR: expected one .xsa in sw/hw/, found %d: deliver the hardware with 'make update-xsa', after 'make xsa'" % len(found), file=sys.stderr)
    sys.exit(1)
xsa = found[0]

# _ide/ is not committed, and without _ide/version.ini set_workspace refuses
# the workspace ("Vitis IDE cannot recognize the workspace version", the
# message the GUI shows with its Update button). The file is written here
# with the Vitis version, the same as the Vivado version of the project; the
# IDE fills in the rest of _ide/ when it opens the workspace.
version_ini = os.path.join(ws, "_ide", "version.ini")
if not os.path.exists(version_ini):
    with open(os.path.join(root, "hw", "VIVADO_VERSION")) as f:
        version = f.read().strip()
    step("initializing the workspace metadata for Vitis " + version)
    os.makedirs(os.path.dirname(version_ini), exist_ok=True)
    with open(version_ini, "w") as f:
        f.write("com.ide.version=" + version + "\n")

client = vitis.create_client()
step("workspace " + ws)
client.set_workspace(path=ws)

for name, component in platforms.items():
    platform_dir = os.path.join(ws, name)
    platform = client.get_component(name=name)

    # Hardware: the copy of the .xsa in hw/ of the platform is not
    # committed, so it is missing after a clone; after 'make xsa' it is old.
    copy = os.path.join(platform_dir, "hw", os.path.basename(xsa))
    if not os.path.exists(copy) or not filecmp.cmp(xsa, copy, shallow=False):
        step(name + ": hardware from " + xsa)
        platform.update_hw(hw_design=xsa)
        for app, app_component in apps.items():
            ide = os.path.join(ws, app, "_ide")
            if app_component["platform"] == name and os.path.isdir(ide):
                step("deleting " + app + "/_ide/ (old bitstream)")
                shutil.rmtree(ide)

    # BSPs: only their configuration and CMake files are committed;
    # regenerate creates the sources in libsrc/ again.
    for domain in component["configuration"]["domains"]:
        if not os.path.isdir(os.path.join(bsp_dir(platform_dir, domain), "libsrc")):
            step(name + ": regenerating the BSP of " + domain["name"])
            platform.get_domain(name=domain["name"]).regenerate()

    if mode == "build":
        step(name + ": building the platform")
        platform.build()

if mode == "update":
    step("workspace ready, not built: build from the GUI or with make vitis-build")
    vitis.dispose()
    sys.exit(0)

for app in apps:
    step(app + ": building the application")
    client.get_component(name=app).build()

# The Vitis calls do not always fail when something goes wrong: the results
# are checked here.
missing = []
for name in platforms:
    fsbl = os.path.join(ws, name, "export", name, "sw", "boot", "fsbl.elf")
    if os.path.exists(fsbl):
        step("ok: " + os.path.relpath(fsbl, ws))
    else:
        missing.append(name + ": no " + fsbl)
for app in apps:
    elf = os.path.join(ws, app, "build", app + ".elf")
    if os.path.exists(elf):
        step("ok: " + os.path.relpath(elf, ws))
    else:
        missing.append(app + ": no " + elf)
if missing:
    fail("the build did not produce:\n  " + "\n  ".join(missing))

# BOOT.bin: Vitis Unified has no system project to make it, so it is written
# here as the Linux part does: FSBL, bitstream, application, in boot order.
if boot_app == "":
    if len(apps) != 1:
        fail("%d applications in the workspace: choose the one for BOOT.bin with VITIS_BOOT_APP in sw/config.sh" % len(apps))
    boot_app = list(apps)[0]
if boot_app not in apps:
    fail("VITIS_BOOT_APP=" + boot_app + " is not an application of the workspace")
# The bitstream comes from the delivered .xsa, which holds it (an .xsa is a
# zip), so that FSBL, application and bitstream match the same hardware.
bit_dir = os.path.join(root, "out", "vitis", "bit")
shutil.rmtree(bit_dir, ignore_errors=True)
os.makedirs(bit_dir)
with zipfile.ZipFile(xsa) as archive:
    names = [n for n in archive.namelist() if n.endswith(".bit")]
    if len(names) != 1:
        fail("expected one .bit inside %s, found %d: write it with 'make xsa'" % (xsa, len(names)))
    bits = [os.path.join(bit_dir, os.path.basename(names[0]))]
    with open(bits[0], "wb") as f:
        f.write(archive.read(names[0]))
platform_name = apps[boot_app]["platform"]
out_dir = os.path.join(root, "out", "vitis")
os.makedirs(out_dir, exist_ok=True)
bif = os.path.join(out_dir, "boot.bif")
with open(bif, "w") as f:
    f.write("the_ROM_image:\n{\n")
    f.write("    [bootloader]" + os.path.join(ws, platform_name, "export", platform_name, "sw", "boot", "fsbl.elf") + "\n")
    f.write("    " + bits[0] + "\n")
    f.write("    " + os.path.join(ws, boot_app, "build", boot_app + ".elf") + "\n")
    f.write("}\n")
step(boot_app + ": out/vitis/BOOT.bin")
result = subprocess.run(["bootgen", "-image", bif, "-arch", "zynq", "-o", os.path.join(out_dir, "BOOT.bin"), "-w", "on"])
if result.returncode != 0:
    fail("bootgen failed")

step("done: %d platform(s), %d application(s), BOOT.bin with %s" % (len(platforms), len(apps), boot_app))
vitis.dispose()
