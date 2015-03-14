LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY TrackerRam IS
  PORT(
      clka  : IN  std_logic;
      wea   : IN  std_logic_vector(0 DOWNTO 0);
      addra : IN  integer;
      dina  : IN  std_logic_vector(31 DOWNTO 0);
      douta : OUT std_logic_vector(31 DOWNTO 0)
    );
END ENTITY TrackerRam;

ARCHITECTURE TrackerRam_synth OF TrackerRam IS
  TYPE memory IS ARRAY(0 TO 31) OF std_logic_vector(31 DOWNTO 0);
  SIGNAL myram                     : memory;
  ATTRIBUTE ram_init_file          : string;
  ATTRIBUTE ram_init_file OF myram : SIGNAL IS "tracker_ram_data.hex";
BEGIN
  PROCESS(clka)
  BEGIN
    IF (clka'event AND clka = '1') THEN
      IF  (to_integer(unsigned(wea))) = 1 THEN
        myram(addra) <= dina;
      END IF;
    END IF;
  END PROCESS;
  douta <= myram(addra);
END ARCHITECTURE;
