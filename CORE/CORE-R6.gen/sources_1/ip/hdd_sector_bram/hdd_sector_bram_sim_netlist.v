// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2 (lin64) Build 3671981 Fri Oct 14 04:59:54 MDT 2022
// Date        : Wed Jul  8 20:59:02 2026
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
