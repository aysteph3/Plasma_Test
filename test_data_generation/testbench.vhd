-- TestBench Template

  LIBRARY ieee;
  library std;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.std_logic_textio.all;
  use ieee.math_real.all;
  use std.textio.all;
  use work.my_package.all;
  use work.mlite_pack.all;

  entity testbench is
  end testbench;

  architecture behavior of testbench is

  -- Component Declaration
          component alu is
          port(
              --clock           : IN std_logic;
               --rst             : IN std_logic;
              a_in         : in  std_logic_vector(31 downto 0);
              b_in         : in  std_logic_vector(31 downto 0);
              alu_function : in  alu_function_type;
              c_alu        : out std_logic_vector(31 downto 0)
               );
          end component;

          --SIGNAL clock          :  std_logic:= '0';
          --SIGNAL rst            :  std_logic := '1';
          signal a_in         :  std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
          signal b_in         :  std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
          signal c_alu        :  std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
          signal alu_function :  std_logic_vector(3 downto 0) := "0000";
          --constant clk_period : time := 10 ns;


  begin
  -- Component Instantiation
      uut: alu port map(
       --clock => clock,
      -- rst=> rst,
             a_in=> a_in,
             b_in=> b_in,
             alu_function=> alu_function,
             c_alu=> c_alu
       );

monitor:
  process
  variable line_v      : line;
  variable line_num    : line;
  file input_file      : text; -- open read_mode is "input.txt";   --declare input file
  file out_file        : text open write_mode is "sim_generated_file/out.txt";
  variable a, b        : string(1 to 32);
  variable char        : character:='0';
  variable num_1       : std_logic_vector (31 downto 0); -- num_1 and num_2 are declared as variable
  variable num_2       : std_logic_vector (31 downto 0);
  variable I           : integer range 0 to 4;
  variable count_value : integer := 0;


  begin
  --wait for 10 ns;
  while (count_value < 9) loop
  file_open(input_file, "sim_input/input.txt", read_mode);
   --while not endfile(input_file) loop
  f: loop
    readline(input_file, line_num);
    read(line_num, a);
    read(line_num, b);
    for idx in 1 to 32 loop
           char := a(idx);
       if(char = '0') then
                  num_1(32-idx) := '0';
                else
                  num_1(32-idx) := '1';
                  end if;
      end loop;

    for id in 1 to 32 loop
           char := b(id);
       if(char = '0') then
                  num_2(32-id) := '0';
                else
                  num_2(32-id) := '1';
                  end if;
      end loop;

    a_in <= num_1;
    b_in <= num_2;
    alu_function <= std_logic_vector(to_unsigned(count_value, 4));
    wait for 1 ns;
      write(line_v, to_bstring(alu_function)& " " & to_bstring(a_in)& " " & to_bstring(b_in)& " " & to_bstring(c_alu));
      writeline(out_file, line_v);
    wait for 4 ns;
    exit f when endfile(input_file);
   end loop; -- end inner while loop
write(line_v, string'(""));
   writeline(out_file, line_v);
   wait for 1 ns;
   file_close(input_file);
   count_value := count_value + 1;
  end loop ; -- end outer while loop
     file_close(out_file);
   wait;
   end process;

  END;
