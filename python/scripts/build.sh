#!/bin/sh
$1/vivado -notrace -nojournal -nolog -mode batch -source $2 -tclargs $3
