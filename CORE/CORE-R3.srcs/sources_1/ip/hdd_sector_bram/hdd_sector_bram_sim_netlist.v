// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2 (lin64) Build 3671981 Fri Oct 14 04:59:54 MDT 2022
// Date        : Tue Jul  7 15:50:45 2026
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
