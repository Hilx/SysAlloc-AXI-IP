LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY rprocessor IS
  GENERIC (N        : natural                       := 8;
           MEMRANGE : std_logic_vector(31 DOWNTO 0) := x"08000000";
           SADDRESS : std_logic_vector(31 DOWNTO 0) := x"00000004"
           );
  PORT (
    clk       : IN  std_logic;
    reset     : IN  std_logic;
    request   : IN  std_logic_vector(31 DOWNTO 0);
    req_valid : IN  std_logic;
    result    : OUT std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');
    res_valid : OUT std_logic;
	done_free : out std_logic;
	
-------
    start   : IN  std_logic;
    command : IN  std_logic;
    done    : OUT std_logic;    
    size    : IN  std_logic_vector(31 DOWNTO 0);
    address : IN  std_logic_vector(31 DOWNTO 0);
    result  : OUT std_logic_vector(31 DOWNTO 0)	
    );
END ENTITY rprocessor;

ARCHITECTURE synthpro OF rprocessor IS

  TYPE stateType IS (s_ready, s_cmd, s_tin, s_busy, s_tout, s_send, s_cmd0);
  SIGNAL state : stateType;

  SIGNAL addr_free   : std_logic_vector(N-1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL size_malloc : std_logic_vector(N-1 DOWNTO 0);

  SIGNAL start, bdone : std_logic;
  SIGNAL size_bin     : std_logic_vector(N-1 DOWNTO 0);
  SIGNAL bresult      : std_logic_vector(N DOWNTO 0);
  SIGNAL command      : std_logic_vector(1 DOWNTO 0);
  SIGNAL size_rout    : std_logic_vector(N-1 DOWNTO 0);
  SIGNAL clientid     : std_logic_vector(N-1 DOWNTO 0) := (OTHERS => '0');
  
component buddy IS
    PORT(
      clk     : IN  std_logic;
      reset   : IN  std_logic;
      start   : IN  std_logic;
      command : IN  std_logic_vector(1 DOWNTO 0);
      done    : OUT std_logic;    
      size    : IN  std_logic_vector(7 DOWNTO 0);
      address : IN  std_logic_vector(7 DOWNTO 0);
      result  : OUT std_logic_vector(8 DOWNTO 0)
      );
      end component buddy;
      
BEGIN
  
  allocator : buddy PORT MAP(
    clk     => clk,
    reset   => reset,
    start   => start,
    command => command,
    done    => bdone,
    size    => size_bin,
    address => addr_free,
    result  => bresult);

  CPROC : PROCESS(command, size_rout, size_malloc)
  BEGIN
    
    size_bin <= size_malloc;
    IF command = "01" THEN
      size_bin <= size_rout;
    END IF;
    
  END PROCESS;

  RPR : PROCESS

    VARIABLE addr_i, phyaddr_i : std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');
  BEGIN
    WAIT UNTIL clk'event AND clk = '1';

    IF reset = '0' THEN
      state <= s_ready;
    ELSE

      IF state = s_ready THEN
        result    <= (OTHERS => '0');
        start     <= '0';
		done_free <= '0';
        res_valid <= '0';
        IF req_valid = '1' THEN
          state   <= s_cmd0;
          command <= request(1 DOWNTO 0);
        END IF;
      END IF;

      IF state = s_cmd0 THEN
        state <= s_cmd;
      END IF;


      IF state = s_cmd THEN
        state <= s_busy;
        start <= '1';
        IF command = "00" THEN          --allocation
          IF unsigned(request(18 DOWNTO 0)) = 0 THEN
            size_malloc <= std_logic_vector(unsigned(request(26 DOWNTO 19))- 1);
          ELSE
            size_malloc <= request(26 DOWNTO 19);
          END IF;
        ELSIF command = "01" THEN       -- free
          addr_i    := std_logic_vector(unsigned(request)- 1 - unsigned(SADDRESS));
          addr_free <= addr_i(26 DOWNTO 19);
        END IF;
        
      END IF;

      IF state = s_busy THEN
        start <= '0';
        IF bdone = '1' THEN
          IF command = "00" THEN
            IF bresult(N) = '1' THEN
              state <= s_tout;
            ELSE
              state  <= s_send;
              result <= (OTHERS => '1');
            END IF;
          ELSIF command = "01" THEN
            state <= s_ready;
			done_free <= '1';
          END IF;
        END IF;
      END IF;

      IF state = s_tout THEN
        state                   <= s_send;
        phyaddr_i(26 DOWNTO 19) := bresult(N-1 DOWNTO 0);
        result                  <= std_logic_vector(unsigned(SADDRESS)+unsigned(phyaddr_i));
      END IF;

      IF state = s_send THEN
        state     <= s_ready;
        res_valid <= '1';
      END IF;

    END IF;
    
  END PROCESS;


END ARCHITECTURE synthpro;
