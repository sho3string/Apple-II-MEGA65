// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2 (lin64) Build 3671981 Fri Oct 14 04:59:54 MDT 2022
// Date        : Sat Aug  1 09:48:54 2026
// Host        : shoestring-virtual-machine running 64-bit Ubuntu 22.04.4 LTS
// Command     : write_verilog -force -mode funcsim
//               /mnt/hgfs/GitHub/Apple-II-MEGA65/CORE/CORE-R6.gen/sources_1/ip/hdd_sector_bram/hdd_sector_bram_sim_netlist.v
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
