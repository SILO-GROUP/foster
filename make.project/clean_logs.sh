#!/bin/bash

echo "Clearing logs ('${logs_dir}')..."
rm -vRf ${logs_dir} && echo "Logs cleared." || echo "Failure to clear logs!"
