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
(1, '1', 1, 0 ),
(2, '1', 1, 0),
(3, '1', 1, 0),
(4, '1', 1, 0),
(5, '0', 1, 2),
(6, '0', 1, 3),
(7, '1', 1, 0),
(8, '1', 1, 0)   
   );
END PACKAGE tb_data;
