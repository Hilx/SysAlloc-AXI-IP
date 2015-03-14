LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.ALL;
USE work.tb_data.ALL;
USE std.textio.ALL;                     --include package textio.vhd
USE ieee.std_logic_textio.ALL;          -- if you're saving this type of signal

ENTITY tb IS
END ENTITY tb;

ARCHITECTURE behav OF tb IS


  ALIAS slv IS std_logic_vector;
  ALIAS usgn IS unsigned;

  TYPE statetype IS (idle, s0, s1, s2, done, s_w);
  SIGNAL state, nstate : statetype;

  SIGNAL clk, reset, start, command, done_bit : std_logic;
  SIGNAL size                                 : std_logic_vector(31 DOWNTO 0);
  SIGNAL address                              : std_logic_vector(31 DOWNTO 0);
  SIGNAL saddr                                : std_logic_vector(31 DOWNTO 0);

  SIGNAL CtrCounter : integer   := 0;
  SIGNAL reqcount   : integer   := 0;
  SIGNAL req_index  : integer;
  SIGNAL endoffile  : std_logic := '0';

  FILE outfile : text OPEN write_mode IS "result.txt";
  
   signal ddr_command    :  std_logic;     -- 0 = write, 1 = read
   signal ddr_start      :  std_logic;
   signal ddr_addr       :  std_logic_vector(31 DOWNTO 0);
   signal ddr_write_data :  std_logic_vector(31 DOWNTO 0);
   signal ddr_read_data  :   std_logic_vector(31 DOWNTO 0);
   signal ddr_done       :   std_logic;

BEGIN
  Buddy_Allocator : ENTITY rbuddy_top
    PORT MAP(
      clk         => clk,
      reset       => reset,
      start       => start,
      cmd         => command,
      size        => size,
      free_addr   => address,
      malloc_addr => saddr,
      done        => done_bit,
	  
	ddr_command   => ddr_command,
    ddr_start    => ddr_start,
    ddr_addr     => ddr_addr, 
    ddr_write_data =>ddr_write_data,
    ddr_read_data  => ddr_read_data,
    ddr_done => ddr_done    
      );

  p1_clkgen : PROCESS
  BEGIN
    clk <= '0';
    WAIT FOR 50 ns;
    clk <= '1';
    WAIT FOR 50 ns;
  END PROCESS p1_clkgen;

  p0 : PROCESS(state, done_bit, reqcount)
  BEGIN
    nstate <= idle;

    CASE state IS
      WHEN idle => nstate <= s0;
      WHEN s0   => nstate <= s1;        -- send req
      WHEN s1   => nstate <= s1;
                   IF done_bit = '1' THEN
                     nstate <= s_w;

                   END IF;
      WHEN s_w => nstate <= s2;
                  IF reqcount = 15 THEN
                    nstate <= done;
                  END IF;
      WHEN s2     => nstate <= s0;
      WHEN done   => nstate <= done;
      WHEN OTHERS => NULL;
    END CASE;
  END PROCESS;

  reset_process : PROCESS

    VARIABLE outline : line;
    VARIABLE out_int : integer;
    VARIABLE v_char  : character;
  BEGIN

    WAIT UNTIL clk'event AND clk = '1';

    CtrCounter <= CtrCounter + 1;
    start      <= '0';

    state <= nstate;

    IF state = s0 THEN
      req_index <= data(reqcount).req_index;
      start     <= '1';
      command   <= data(reqcount).command;
      size      <= slv(to_unsigned(data(reqcount).size, size'length));
      address   <= slv(to_unsigned(data(reqcount).address, address'length));
    END IF;

    IF state = s_w THEN
      IF(endoffile = '0') THEN
        
        IF command = '0' THEN           -- allotcation
          write(outline, data(reqcount).req_index);
          write(outline, string'(" saddr =  "));
          out_int := to_integer(usgn(saddr));
          write(outline, out_int);
          writeline(outfile, outline);
        ELSE
          write(outline, req_index);
          writeline(outfile, outline);
        END IF;
        
        
      END IF;
    END IF;

    IF state = s2 THEN
      
      reqcount <= reqcount + 1;
    END IF;

  END PROCESS;

END ARCHITECTURE;
