// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2 (lin64) Build 3671981 Fri Oct 14 04:59:54 MDT 2022
// Date        : Sun Jul 26 22:25:27 2026
// Host        : shoestring-virtual-machine running 64-bit Ubuntu 22.04.4 LTS
// Command     : write_verilog -force -mode funcsim -rename_top hdd_sector_bram -prefix
//               hdd_sector_bram_ hdd_sector_bram_sim_netlist.v
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 22144)
`pragma protect data_block
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
rIem4pb9sY6gQRK2BRLjOpZvlladVThmdNnCBQ==
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
