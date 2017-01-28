#!/bin/sh
pactl load-module module-jack-sink sink_name=jackVoipSink channels=2 sink_properties=device.description="voip-sink"
pactl load-module module-jack-sink sink_name=jackSystemSink channels=2 sink_properties=device.description="system-sink"
pactl load-module module-jack-source source_name=jackVoipSource channels=2 source_properties=device.description="voip-source"
pactl load-module module-jack-source source_name=jackOBSSource channels=2 source_properties=device.description="obs-source"

