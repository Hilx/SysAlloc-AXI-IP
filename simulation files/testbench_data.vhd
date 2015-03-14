LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.ALL;

PACKAGE tb_data IS

  TYPE data_t_rec IS
  RECORD
    req_index : integer;
    command   : std_logic;              -- 0 = allocation, 1 = '1'
    size      : integer;
    address   : integer;
  END RECORD;

  TYPE data_t IS ARRAY (natural RANGE <>) OF data_t_rec;



  CONSTANT data : data_t := (
(1, '1', 393216, 0 ),
(2, '1', 393216, 0),
(3, '1', 589824, 0),
(4, '1', 589824, 0),
(5, '1', 589824, 0),
(6, '1', 589824, 0),
(7, '1', 393216, 0),
(8, '1', 393216, 0)   
   );
END PACKAGE tb_data;
