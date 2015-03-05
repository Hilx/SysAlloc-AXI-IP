LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

PACKAGE budpack IS

  -- total number of memory blocks managed by the allocator
  CONSTANT TOTAL_MEM_BLOCKS : std_logic_vector(31 DOWNTO 0) := std_logic_vector(to_unsigned(512, 32));
  -- log2(total number of memory blocks)
  CONSTANT LOG2TMB          : std_logic_vector(6 DOWNTO 0)  := std_logic_vector(to_unsigned(9, 7));  -- MAX TREE DEPTH
  CONSTANT MAX_TREE_DEPTH   : integer                       := 9;
  -- if the allocation vector is used, the starting address of it. DON'T KNOW YET!
  CONSTANT USE_ALVEC        : std_logic                     := '0';
  CONSTANT ALVEC_SHIFT      : std_logic_vector(31 DOWNTO 0) := std_logic_vector(to_unsigned(10000, 32));



  TYPE tree_probe IS RECORD  -- possible type for interface from DB to RCD. Change as required
    verti   : std_logic_vector(31 DOWNTO 0);
    horiz   : std_logic_vector(31 DOWNTO 0);
    nodesel : std_logic_vector(2 DOWNTO 0);  -- 8 nodes to select from
    saddr   : std_logic_vector(31 DOWNTO 0);
    rowbase : std_logic_vector(31 DOWNTO 0);
    alvec   : std_logic;
  END RECORD;

  TYPE holder_type IS RECORD
    mtree   : std_logic_vector(31 DOWNTO 0);
    nodesel : std_logic_vector(2 DOWNTO 0);
    gaddr   : std_logic_vector(31 DOWNTO 0);
  END RECORD;

END PACKAGE budpack;

