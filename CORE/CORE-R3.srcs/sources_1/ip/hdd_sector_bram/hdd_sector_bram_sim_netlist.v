// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2 (lin64) Build 3671981 Fri Oct 14 04:59:54 MDT 2022
// Date        : Sun Jul 26 22:25:29 2026
// Host        : shoestring-virtual-machine running 64-bit Ubuntu 22.04.4 LTS
// Command     : write_verilog -force -mode funcsim
//               /mnt/hgfs/GitHub/Apple-II-MEGA65/CORE/CORE-R3.srcs/sources_1/ip/hdd_sector_bram/hdd_sector_bram_sim_netlist.v
// Design      : hdd_sector_bram
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tfbg484-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "hdd_sector_bram,blk_mem_gen_v8_4_5,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_5,Vivado 2022.2" *) 
(* NotValidForBitStream *)
module hdd_sector_bram
   (clka,
    ena,
    regcea,
    wea,
    addra,
    dina,
    douta,
    clkb,
    enb,
    web,
    addrb,
    dinb,
    doutb);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  input regcea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [8:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [7:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [7:0]douta;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB EN" *) input enb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB WE" *) input [0:0]web;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [8:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DIN" *) input [7:0]dinb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [7:0]doutb;

  wire [8:0]addra;
  wire [8:0]addrb;
  wire clka;
  wire clkb;
  wire [7:0]dina;
  wire [7:0]dinb;
  wire [7:0]douta;
  wire [7:0]doutb;
  wire ena;
  wire enb;
  wire regcea;
  wire [0:0]wea;
  wire [0:0]web;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [8:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [8:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [7:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "9" *) 
  (* C_ADDRB_WIDTH = "9" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "1" *) 
  (* C_COUNT_36K_BRAM = "0" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     2.7033 mW" *) 
  (* C_FAMILY = "artix7" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "1" *) 
  (* C_HAS_ENB = "1" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "1" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "1" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "1" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "hdd_sector_bram.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "2" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "512" *) 
  (* C_READ_DEPTH_B = "512" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "8" *) 
  (* C_READ_WIDTH_B = "8" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "0" *) 
  (* C_USE_BYTE_WEB = "0" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "1" *) 
  (* C_WEB_WIDTH = "1" *) 
  (* C_WRITE_DEPTH_A = "512" *) 
  (* C_WRITE_DEPTH_B = "512" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "8" *) 
  (* C_WRITE_WIDTH_B = "8" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  hdd_sector_bram_blk_mem_gen_v8_4_5 U0
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .clkb(clkb),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb(dinb),
        .douta(douta),
        .doutb(doutb),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(enb),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[8:0]),
        .regcea(regcea),
        .regceb(1'b0),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[8:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[7:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web(web));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2022.2"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
VHPlDkoDlWlBfBMvPBmGYmaek3s9hXXhjF28kllYPnaNm3TSnzzpXHWHc8Ye9/2L2yiQfJ1hTWou
Ia/zeQ8h9/dtr6QB5YkyW4wlb/LbMgXb+DGIXPSllNl0IMsRQIcQDbcQm1bO/nlhb+2pjxiuaQrl
DbvxoDwPs7z3LunRxsg=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
lmIhoX8hXuc7tNV1sXY1K2/gXL7Y7Hq73qQF7+x03UWWTRd3uhGmVQtOMVbhIW+66UkWUHiD26zL
fzqGor8bgSNGpSFyS11k4TwLQT4OfAMGO8C9Qmmh4+VENBnpS9TW+wHzCv8oUwht7xYtYRZvOvYK
F3fMppz2sBkUd1lciw98ZE/UmNkhqBuMfIYF43j45DEJ55PBhOZNg91Ls4v3qBHyBAaYPFFoMry3
d5Fw1PZyFQSEOSSpwgyds2aN0g6oIwl7zm0LJrM9VDAOxBUE50hk+oHr4jj8J8UhHQJnlEHm1Idm
rvxKygNKRvfSpa90NYxZJFYgqnrMYg+19+9aZA==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
VkyCjO2onoeZWEoYQ/4ue7X5mkHyTYVW9xjdoTsGS4GdP/Q64VaCZL/jr6R8DVDXPMnH7tRMrDpo
jpYBnyzSgOkfgqM+96ioC2fDyAaG4gYgGLmrBR6qK3/mxXwAZZX+GJ9R/eWXkc9h8xN+gsSSX6/M
jIQCgeT6q7PB4dWT6KY=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Iub91V+TnhVlZCSLu6iKmFjix71y6/l83OPTs8uewWvkE7WcqYxEKi9fonXEkzAtWzuKwEUqnOlN
VBsNJqPUdKcd22q523mrdt89mpdosWD+hvZdO7ELhJniY5u9h49FFkubpN2JiUTcIcKEYxVNlds4
wyvaYUqbPVH5v2ooJwDdimS4GVn9HerCOgPwfshvQDNlMTxLcYju4v8BHMc5Rub9Q/ihvpQU74v2
ouZ9XIwA+C6pBLwvaqS8jE7HXOokgqJilaX/W/t+KEgiFry/txRTMU9WMD7tCN7lcfjCydmS3Lq+
3u6Hsr0S8BwNjcaDpZDnBTygUJd4JSqREnk33w==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
U46EWFmKmpZGaWfyL+dokyQtJtaOYsa7HCW/+fdtw9/yHKTWFpmqKBZngBj5rPkNhtTDDCJkqsYj
tUXg1j4tgIBaCQn9B0q/aG+B3gPLrudp9hLL25mVbsfiTzdekiV2hJMmhuMoavKKPJHC6zyW7kZi
80er82OQy8h+Df/fe6TRjH9xEt3/b80tRKUMbxkLfnnkAyyf1KfOhB6/uyI4mwXuQR+DsAbzybKR
YtXpOiW72tGrXTFlzcwbHamWZefqsilVpBw6V5dh33vYKGx50xwWpj76maAkpQrOpB7zufeldJe4
W1UOEN84AZdRTLkVSxamWo/wp8nP9fiGS/ItRw==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2021_07", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
qczgIJYpE/SzErzK7eWJBGcDFEzDLm8cKbwJbPXuM6YnJxx44W+E60R3war7K2QGFAkOoCDUtDC7
SghJGF32btaDLzeKm0tQ669sBtQmMIaBrlt7I9QBkNM8zN9GL92qxNC9o3UVWMOYy5BmH8nUPgcE
O6lRubeltlrTuDe7UJQ2nEPHcXjpUJJ8dxktyW+LovBy1OxW8g4GRAsmEJsoOEg0HuDdWcc4IshJ
PvwPJ7LblELAKsdkSt65y9VaklaEm7MlH4ImlgIa74TgRmutLUbWxM1QYhGE5rAzFhGU5i3RJOdx
L3N7GGGvLMW2z9NSHbIFX+/eNII9fNJ9nZbgLA==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Ti1NUgDv8YPk90APMwfu/mRr38QYwAxZfv0T6zQ89YS55t2EquEGVqrEafYX6rTydLOw8le1Oucv
f2oERpSSSTih/ScZneSZmuPE/Zh2BU1Ajv0j+/+0uEWXU+5lLPbDJjnapTmJXih1MYPf0SHpZZmE
BKj2IEBI9MPZlh6bxpa5BWJnyPdAvHf+UNaMXU9+pmbtrzUVebql4mFJu45Z3+ehmFY4FBW3zXMF
44C4TlHACLwL3vHVMCVfeKhgdVDbpE+/IFhTStz7mZ9h9RKGanQcs6YDVM1R+2RKA1QT1fX4FiQc
1V+FGmrm1ujxmFGXwpfNKByVlfCY0oWhRJCYYQ==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
HuEXFK0NXt09xU2yxxjng1OLsT+ZEM4EhqBgpr9D2ljw2vDaMBrqEsRQTc2B9soDq3ewDduHJXBd
OGYxkPnoN6LhjULtB2nTgjcH6NxA4puZ1ZNcndDndVBo8rTW5W1OqHq6InAG0CqPpTIkuqz3ECPl
EysI++MCDfH6tIzlekxJFIJ1McJsTq5rFuLzMMcrmkBxgcayDpOcCFuzZzCczxmt/cCCIKmDybwT
OQXmOcLJoYLP4sFu6R9c6xO8i6p++crv2N3eIxZHKbek9xBBZqQM9EYuEtsbkqAs9XZpa16i5njR
BDFxTKcP6r7JgFALJE89AZhBbate5JXWp0v4ECZD18aEL17CipwcWPutNMdG1apzSPP5y59n7rMG
yxBPz1gKHc3Emkl4WcO0hjICxqmO6dMXoY8JvBSf6ry2l0sH9Ihr3Bq5WWmlhPHnoaNr5jl//vNe
KfToWtn97eoVSt1LnmXXnSpdigbHr0UIg8AdkpdkuNRaWdVicDdgSo49

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
mokwst2bn6UxD6V9UdIgCIG1QQ/d0FiJqYGOTI2eHPV6YElaLjnJ8DnQmZnGS95o3x93FDOoa58C
RwYsX1fVoVtXkj1LuZq0k7q9vEe4T8xMjpkeYtIHY9k0Xhy1Lq/xRlfzGAf9fvf9e+f4r7aR/Sb/
uCZxxugG5niTwLENY1n3NthYL0jvo8Fmdw4Qg0nTCGWlVCws+09K0g9/lx6I9EcuHHemcHO3fOZG
lMc4NaPNozKwnyDMoWUkwiVxyFEPFaQLNYqzjvR+CqrWfhFLo96JWhL+eaDoNuZoBVYQtNH5ZwBL
BoO27Pw10lgcReGlZBz3BLO7T4ddynCx0+eSnw==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
PiP7AjOQqqouyQMoBQqgWIDhUSViq94rIvGiIJ/UKMDspM/yXw1caE8AhWHTjYckC4yLpPAz5P6s
1Z6flzDPrzVwg4e59X2cc4IMCHhedna0rDO804njcc6amRDTeLsMLTkWfvomB4xwszm2AgT+PRnB
WHd09ZUDVFjiBXT+Oa9AicgGJHrX3w823yBPuAa704kje/SzgtiDpcTU1eLmLhLW7LpEd9KIHd9s
ER7Uk9Orws0Kq9PMTqMX4hMn5K5mFakOeOURiEbUjdv5RiIJ2g/PlQXSItM8fHsBTQa6fOaJwQTI
vHwK3a8ZBHpfT1YH+n7wNiNUZwD4SFXm1QVx4g==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Ul5ZfTHJwMctaNhYRortUZizYMPYRef7uYqPSuMkxsArnxI/cjGh+KRMwzV86hyp/6TXSJIjm5ec
2wX2UONdPN+DOJ84jYC4JbgJQrPnTj7ioD8uLX/WlyPcQzyF5keqFgj5eR5s13FskVWCuAWf5m9w
mhFEKFjVXDAr7gVgAJh/hL8P6Psrnf+LGfiM8JhnDepsHEYykGlpD3fzru2BGgqHWqPqFMcnyVGl
vysaIXiJz/eYKvO8RGcgd3DJAM/wPm9A0m/DWcmSnczOgTjoqkHcBg2H5uJMLvufzmjImi6LYEqq
v04ESDEN31cSUzqUYcayvMFOnI/WNsWbFIa5+Q==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 22432)
`pragma protect data_block
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
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
