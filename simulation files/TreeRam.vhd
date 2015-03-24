LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
use work.budpack.all;

ENTITY TreeBram IS
  PORT(
      clka  : IN  std_logic;
      wea   : IN  std_logic_vector(0 DOWNTO 0);
      addra : IN  std_logic_vector(31 DOWNTO 0);
      dina  : IN  std_logic_vector(31 DOWNTO 0);
      douta : OUT std_logic_vector(31 DOWNTO 0)
    );
END ENTITY TreeBram;

ARCHITECTURE TreeBram_synth OF TreeBram IS
  TYPE memory IS ARRAY(0 TO 2396745) OF std_logic_vector(31 DOWNTO 0);
  SIGNAL myram                     : memory;
  ATTRIBUTE ram_init_file          : string;
  ATTRIBUTE ram_init_file OF myram : SIGNAL IS "ram_data.hex";
BEGIN
  PROCESS(clka)
  BEGIN
    IF (clka'event AND clka = '1') THEN
      IF (to_integer(unsigned(wea))) = 1 THEN
        myram(to_integer(unsigned(addra))) <= dina;
      END IF;
    END IF;
  END PROCESS;
  douta <= myram(to_integer(unsigned(addra)));
END ARCHITECTURE TreeBram_synth;
