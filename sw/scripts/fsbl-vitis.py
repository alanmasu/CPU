# FSBL from the .xsa with the Vitis Python API (Vitis 2024.2 and newer).
# Run by build.sh with: vitis -s fsbl-vitis.py
# Paths come from the environment:
#   XSA        the hardware platform
#   OUT_DIR    the Vitis workspace to create
#   PROCESSOR  for example ps7_cortexa9_0
#
# A standalone platform on the processor comes with its boot components:
# for a Zynq-7000 that is the FSBL, built together with the platform.

import os

import vitis

xsa = os.environ["XSA"]
out_dir = os.environ["OUT_DIR"]
processor = os.environ["PROCESSOR"]

client = vitis.create_client()
client.set_workspace(path=out_dir)
platform = client.create_platform_component(
    name="platform",
    hw_design=xsa,
    os="standalone",
    cpu=processor,
    domain_name="standalone_" + processor,
)
platform.build()
vitis.dispose()
