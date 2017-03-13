#! /bin/bash
perl -pi -e \
  's/^ *(FOR ALL : .* USE ENTITY tripole_lib)/-- $1/; s/^(LIBRARY tripole_lib)/-- $1/' \
  *_struct.vhd \
  tri_wrap_tb_tb_rtl.vhd

