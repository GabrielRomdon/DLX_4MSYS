###################################################################

# Created by write_sdc on Mon May 30 18:40:55 2022

###################################################################
set sdc_version 1.9

set_units -time ns -resistance MOhm -capacitance fF -voltage V -current mA
set_wire_load_model -name 5K_hvratio_1_4 -library NangateOpenCellLibrary
create_clock [get_ports CLK]  -name MY_CLK  -period 0.954143  -waveform {0 0.477071}
set_max_delay 0.954143  -from [list [get_ports CLK] [get_ports RST] [get_ports {I_DATA[31]}]          \
[get_ports {I_DATA[30]}] [get_ports {I_DATA[29]}] [get_ports {I_DATA[28]}]     \
[get_ports {I_DATA[27]}] [get_ports {I_DATA[26]}] [get_ports {I_DATA[25]}]     \
[get_ports {I_DATA[24]}] [get_ports {I_DATA[23]}] [get_ports {I_DATA[22]}]     \
[get_ports {I_DATA[21]}] [get_ports {I_DATA[20]}] [get_ports {I_DATA[19]}]     \
[get_ports {I_DATA[18]}] [get_ports {I_DATA[17]}] [get_ports {I_DATA[16]}]     \
[get_ports {I_DATA[15]}] [get_ports {I_DATA[14]}] [get_ports {I_DATA[13]}]     \
[get_ports {I_DATA[12]}] [get_ports {I_DATA[11]}] [get_ports {I_DATA[10]}]     \
[get_ports {I_DATA[9]}] [get_ports {I_DATA[8]}] [get_ports {I_DATA[7]}]        \
[get_ports {I_DATA[6]}] [get_ports {I_DATA[5]}] [get_ports {I_DATA[4]}]        \
[get_ports {I_DATA[3]}] [get_ports {I_DATA[2]}] [get_ports {I_DATA[1]}]        \
[get_ports {I_DATA[0]}] [get_ports {D_DATA_OUT[31]}] [get_ports                \
{D_DATA_OUT[30]}] [get_ports {D_DATA_OUT[29]}] [get_ports {D_DATA_OUT[28]}]    \
[get_ports {D_DATA_OUT[27]}] [get_ports {D_DATA_OUT[26]}] [get_ports           \
{D_DATA_OUT[25]}] [get_ports {D_DATA_OUT[24]}] [get_ports {D_DATA_OUT[23]}]    \
[get_ports {D_DATA_OUT[22]}] [get_ports {D_DATA_OUT[21]}] [get_ports           \
{D_DATA_OUT[20]}] [get_ports {D_DATA_OUT[19]}] [get_ports {D_DATA_OUT[18]}]    \
[get_ports {D_DATA_OUT[17]}] [get_ports {D_DATA_OUT[16]}] [get_ports           \
{D_DATA_OUT[15]}] [get_ports {D_DATA_OUT[14]}] [get_ports {D_DATA_OUT[13]}]    \
[get_ports {D_DATA_OUT[12]}] [get_ports {D_DATA_OUT[11]}] [get_ports           \
{D_DATA_OUT[10]}] [get_ports {D_DATA_OUT[9]}] [get_ports {D_DATA_OUT[8]}]      \
[get_ports {D_DATA_OUT[7]}] [get_ports {D_DATA_OUT[6]}] [get_ports             \
{D_DATA_OUT[5]}] [get_ports {D_DATA_OUT[4]}] [get_ports {D_DATA_OUT[3]}]       \
[get_ports {D_DATA_OUT[2]}] [get_ports {D_DATA_OUT[1]}] [get_ports             \
{D_DATA_OUT[0]}]]
set_max_delay 0.954143  -from [list [get_ports CLK] [get_ports RST] [get_ports {I_DATA[31]}]          \
[get_ports {I_DATA[30]}] [get_ports {I_DATA[29]}] [get_ports {I_DATA[28]}]     \
[get_ports {I_DATA[27]}] [get_ports {I_DATA[26]}] [get_ports {I_DATA[25]}]     \
[get_ports {I_DATA[24]}] [get_ports {I_DATA[23]}] [get_ports {I_DATA[22]}]     \
[get_ports {I_DATA[21]}] [get_ports {I_DATA[20]}] [get_ports {I_DATA[19]}]     \
[get_ports {I_DATA[18]}] [get_ports {I_DATA[17]}] [get_ports {I_DATA[16]}]     \
[get_ports {I_DATA[15]}] [get_ports {I_DATA[14]}] [get_ports {I_DATA[13]}]     \
[get_ports {I_DATA[12]}] [get_ports {I_DATA[11]}] [get_ports {I_DATA[10]}]     \
[get_ports {I_DATA[9]}] [get_ports {I_DATA[8]}] [get_ports {I_DATA[7]}]        \
[get_ports {I_DATA[6]}] [get_ports {I_DATA[5]}] [get_ports {I_DATA[4]}]        \
[get_ports {I_DATA[3]}] [get_ports {I_DATA[2]}] [get_ports {I_DATA[1]}]        \
[get_ports {I_DATA[0]}] [get_ports {D_DATA_OUT[31]}] [get_ports                \
{D_DATA_OUT[30]}] [get_ports {D_DATA_OUT[29]}] [get_ports {D_DATA_OUT[28]}]    \
[get_ports {D_DATA_OUT[27]}] [get_ports {D_DATA_OUT[26]}] [get_ports           \
{D_DATA_OUT[25]}] [get_ports {D_DATA_OUT[24]}] [get_ports {D_DATA_OUT[23]}]    \
[get_ports {D_DATA_OUT[22]}] [get_ports {D_DATA_OUT[21]}] [get_ports           \
{D_DATA_OUT[20]}] [get_ports {D_DATA_OUT[19]}] [get_ports {D_DATA_OUT[18]}]    \
[get_ports {D_DATA_OUT[17]}] [get_ports {D_DATA_OUT[16]}] [get_ports           \
{D_DATA_OUT[15]}] [get_ports {D_DATA_OUT[14]}] [get_ports {D_DATA_OUT[13]}]    \
[get_ports {D_DATA_OUT[12]}] [get_ports {D_DATA_OUT[11]}] [get_ports           \
{D_DATA_OUT[10]}] [get_ports {D_DATA_OUT[9]}] [get_ports {D_DATA_OUT[8]}]      \
[get_ports {D_DATA_OUT[7]}] [get_ports {D_DATA_OUT[6]}] [get_ports             \
{D_DATA_OUT[5]}] [get_ports {D_DATA_OUT[4]}] [get_ports {D_DATA_OUT[3]}]       \
[get_ports {D_DATA_OUT[2]}] [get_ports {D_DATA_OUT[1]}] [get_ports             \
{D_DATA_OUT[0]}]]  -to [list [get_ports {I_ADDR[31]}] [get_ports {I_ADDR[30]}] [get_ports        \
{I_ADDR[29]}] [get_ports {I_ADDR[28]}] [get_ports {I_ADDR[27]}] [get_ports     \
{I_ADDR[26]}] [get_ports {I_ADDR[25]}] [get_ports {I_ADDR[24]}] [get_ports     \
{I_ADDR[23]}] [get_ports {I_ADDR[22]}] [get_ports {I_ADDR[21]}] [get_ports     \
{I_ADDR[20]}] [get_ports {I_ADDR[19]}] [get_ports {I_ADDR[18]}] [get_ports     \
{I_ADDR[17]}] [get_ports {I_ADDR[16]}] [get_ports {I_ADDR[15]}] [get_ports     \
{I_ADDR[14]}] [get_ports {I_ADDR[13]}] [get_ports {I_ADDR[12]}] [get_ports     \
{I_ADDR[11]}] [get_ports {I_ADDR[10]}] [get_ports {I_ADDR[9]}] [get_ports      \
{I_ADDR[8]}] [get_ports {I_ADDR[7]}] [get_ports {I_ADDR[6]}] [get_ports        \
{I_ADDR[5]}] [get_ports {I_ADDR[4]}] [get_ports {I_ADDR[3]}] [get_ports        \
{I_ADDR[2]}] [get_ports {I_ADDR[1]}] [get_ports {I_ADDR[0]}] [get_ports D_RR]  \
[get_ports D_WR] [get_ports {D_ADDR[5]}] [get_ports {D_ADDR[4]}] [get_ports    \
{D_ADDR[3]}] [get_ports {D_ADDR[2]}] [get_ports {D_ADDR[1]}] [get_ports        \
{D_ADDR[0]}] [get_ports {D_DATA_IN[31]}] [get_ports {D_DATA_IN[30]}]           \
[get_ports {D_DATA_IN[29]}] [get_ports {D_DATA_IN[28]}] [get_ports             \
{D_DATA_IN[27]}] [get_ports {D_DATA_IN[26]}] [get_ports {D_DATA_IN[25]}]       \
[get_ports {D_DATA_IN[24]}] [get_ports {D_DATA_IN[23]}] [get_ports             \
{D_DATA_IN[22]}] [get_ports {D_DATA_IN[21]}] [get_ports {D_DATA_IN[20]}]       \
[get_ports {D_DATA_IN[19]}] [get_ports {D_DATA_IN[18]}] [get_ports             \
{D_DATA_IN[17]}] [get_ports {D_DATA_IN[16]}] [get_ports {D_DATA_IN[15]}]       \
[get_ports {D_DATA_IN[14]}] [get_ports {D_DATA_IN[13]}] [get_ports             \
{D_DATA_IN[12]}] [get_ports {D_DATA_IN[11]}] [get_ports {D_DATA_IN[10]}]       \
[get_ports {D_DATA_IN[9]}] [get_ports {D_DATA_IN[8]}] [get_ports               \
{D_DATA_IN[7]}] [get_ports {D_DATA_IN[6]}] [get_ports {D_DATA_IN[5]}]          \
[get_ports {D_DATA_IN[4]}] [get_ports {D_DATA_IN[3]}] [get_ports               \
{D_DATA_IN[2]}] [get_ports {D_DATA_IN[1]}] [get_ports {D_DATA_IN[0]}]]
set_max_delay 0.954143  -to [get_ports {I_ADDR[31]}]
set_max_delay 0.954143  -to [get_ports {I_ADDR[30]}]
set_max_delay 0.954143  -to [get_ports {I_ADDR[29]}]
set_max_delay 0.954143  -to [get_ports {I_ADDR[28]}]
set_max_delay 0.954143  -to [get_ports {I_ADDR[27]}]
set_max_delay 0.954143  -to [get_ports {I_ADDR[26]}]
set_max_delay 0.954143  -to [get_ports {I_ADDR[25]}]
set_max_delay 0.954143  -to [get_ports {I_ADDR[24]}]
set_max_delay 0.954143  -to [get_ports {I_ADDR[23]}]
set_max_delay 0.954143  -to [get_ports {I_ADDR[22]}]
set_max_delay 0.954143  -to [get_ports {I_ADDR[21]}]
set_max_delay 0.954143  -to [get_ports {I_ADDR[20]}]
set_max_delay 0.954143  -to [get_ports {I_ADDR[19]}]
set_max_delay 0.954143  -to [get_ports {I_ADDR[18]}]
set_max_delay 0.954143  -to [get_ports {I_ADDR[17]}]
set_max_delay 0.954143  -to [get_ports {I_ADDR[16]}]
set_max_delay 0.954143  -to [get_ports {I_ADDR[15]}]
set_max_delay 0.954143  -to [get_ports {I_ADDR[14]}]
set_max_delay 0.954143  -to [get_ports {I_ADDR[13]}]
set_max_delay 0.954143  -to [get_ports {I_ADDR[12]}]
set_max_delay 0.954143  -to [get_ports {I_ADDR[11]}]
set_max_delay 0.954143  -to [get_ports {I_ADDR[10]}]
set_max_delay 0.954143  -to [get_ports {I_ADDR[9]}]
set_max_delay 0.954143  -to [get_ports {I_ADDR[8]}]
set_max_delay 0.954143  -to [get_ports {I_ADDR[7]}]
set_max_delay 0.954143  -to [get_ports {I_ADDR[6]}]
set_max_delay 0.954143  -to [get_ports {I_ADDR[5]}]
set_max_delay 0.954143  -to [get_ports {I_ADDR[4]}]
set_max_delay 0.954143  -to [get_ports {I_ADDR[3]}]
set_max_delay 0.954143  -to [get_ports {I_ADDR[2]}]
set_max_delay 0.954143  -to [get_ports {I_ADDR[1]}]
set_max_delay 0.954143  -to [get_ports {I_ADDR[0]}]
set_max_delay 0.954143  -to [get_ports D_RR]
set_max_delay 0.954143  -to [get_ports D_WR]
set_max_delay 0.954143  -to [get_ports {D_ADDR[5]}]
set_max_delay 0.954143  -to [get_ports {D_ADDR[4]}]
set_max_delay 0.954143  -to [get_ports {D_ADDR[3]}]
set_max_delay 0.954143  -to [get_ports {D_ADDR[2]}]
set_max_delay 0.954143  -to [get_ports {D_ADDR[1]}]
set_max_delay 0.954143  -to [get_ports {D_ADDR[0]}]
set_max_delay 0.954143  -to [get_ports {D_DATA_IN[31]}]
set_max_delay 0.954143  -to [get_ports {D_DATA_IN[30]}]
set_max_delay 0.954143  -to [get_ports {D_DATA_IN[29]}]
set_max_delay 0.954143  -to [get_ports {D_DATA_IN[28]}]
set_max_delay 0.954143  -to [get_ports {D_DATA_IN[27]}]
set_max_delay 0.954143  -to [get_ports {D_DATA_IN[26]}]
set_max_delay 0.954143  -to [get_ports {D_DATA_IN[25]}]
set_max_delay 0.954143  -to [get_ports {D_DATA_IN[24]}]
set_max_delay 0.954143  -to [get_ports {D_DATA_IN[23]}]
set_max_delay 0.954143  -to [get_ports {D_DATA_IN[22]}]
set_max_delay 0.954143  -to [get_ports {D_DATA_IN[21]}]
set_max_delay 0.954143  -to [get_ports {D_DATA_IN[20]}]
set_max_delay 0.954143  -to [get_ports {D_DATA_IN[19]}]
set_max_delay 0.954143  -to [get_ports {D_DATA_IN[18]}]
set_max_delay 0.954143  -to [get_ports {D_DATA_IN[17]}]
set_max_delay 0.954143  -to [get_ports {D_DATA_IN[16]}]
set_max_delay 0.954143  -to [get_ports {D_DATA_IN[15]}]
set_max_delay 0.954143  -to [get_ports {D_DATA_IN[14]}]
set_max_delay 0.954143  -to [get_ports {D_DATA_IN[13]}]
set_max_delay 0.954143  -to [get_ports {D_DATA_IN[12]}]
set_max_delay 0.954143  -to [get_ports {D_DATA_IN[11]}]
set_max_delay 0.954143  -to [get_ports {D_DATA_IN[10]}]
set_max_delay 0.954143  -to [get_ports {D_DATA_IN[9]}]
set_max_delay 0.954143  -to [get_ports {D_DATA_IN[8]}]
set_max_delay 0.954143  -to [get_ports {D_DATA_IN[7]}]
set_max_delay 0.954143  -to [get_ports {D_DATA_IN[6]}]
set_max_delay 0.954143  -to [get_ports {D_DATA_IN[5]}]
set_max_delay 0.954143  -to [get_ports {D_DATA_IN[4]}]
set_max_delay 0.954143  -to [get_ports {D_DATA_IN[3]}]
set_max_delay 0.954143  -to [get_ports {D_DATA_IN[2]}]
set_max_delay 0.954143  -to [get_ports {D_DATA_IN[1]}]
set_max_delay 0.954143  -to [get_ports {D_DATA_IN[0]}]
