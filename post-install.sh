#!/bin/sh
# Remove unnecessary files to reduce space.

rm -r /opt/include

rm /opt/lib/*.a
rm /opt/lib/*.la

rm -r /opt/share/doc
rm -r /opt/share/man