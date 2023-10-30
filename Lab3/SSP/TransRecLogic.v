module TransRecLogic(
    input [7:0] TxData,
    input pclk, clr_b, t_empty, r_full,
    output [7:0] RxData,
    output read_en, inc_ptr
);
