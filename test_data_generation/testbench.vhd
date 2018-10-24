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
                a_in         : in  std_logic_vector(31 downto 0);
                b_in         : in  std_logic_vector(31 downto 0);
                alu_function : in  alu_function_type;
                c_alu        : out std_logic_vector(31 downto 0));
          end component;

          component mult is
              port(clk       : in std_logic;
                  reset_in  : in std_logic;
                  a, b      : in std_logic_vector(31 downto 0);
                  mult_func : in mult_function_type;
                  c_mult    : out std_logic_vector(31 downto 0);
                  pause_out : out std_logic);
          end component;

          component shifter is
             --generic(shifter_type : string := "DEFAULT");
             port(value        : in  std_logic_vector(31 downto 0);
                  shift_amount : in  std_logic_vector(4 downto 0);
                  shift_func   : in  shift_function_type;
                  c_shift      : out std_logic_vector(31 downto 0));
          end component;

          signal clk          :  std_logic:= '1';
          signal reset_in     :  std_logic;
          signal a_in         :  std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
          signal b_in         :  std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
          signal c_alu        :  std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
          signal alu_function :  std_logic_vector(3 downto 0) := "0000";

          signal c_mult       :  std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
          signal mult_func    :  std_logic_vector(3 downto 0) := "0000";
          signal pause_out    :  std_logic := '0';

          signal value         :  std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
          signal shift_func   :  std_logic_vector(1 downto 0) := "00";
          signal shift_amount :  std_logic_vector(4 downto 0) := "00010";
          signal c_shift      :  std_logic_vector(31 downto 0) := "00000000000000000000000000000000";

          constant clk_period : time := 10 ns;


  begin
  -- Component Instantiation
      uut: alu port map(
                          a_in=> a_in,
                          b_in=> b_in,
                          alu_function=> alu_function,
                          c_alu=> c_alu);


      uut2: mult port map(
                          clk=> clk,
                          reset_in=> reset_in,
                          a=> a_in,
                          b=> b_in,
                          mult_func=> mult_func,
                          c_mult=> c_mult,
                          pause_out => pause_out);


      uut3: shifter port map(
                          value=> value,
                          shift_amount=> shift_amount,
                          shift_func=> shift_func,
                          c_shift=> c_shift);

     --Test Bench Statements
     --clk <= not clk after 10 ns;
     reset_in <= '0' after 1 ns;

--clk_process:
-- process
--  begin
--      clk <= '0';
--      wait for clk_period/2;  --for 0.5 ns signal is '0'.
--      clk <= '1';
--      wait for clk_period/2;  --for next 0.5 ns signal is '1'.
--  end process;

monitor:
  process
  variable line_v      : line;
  variable line_num    : line;
  variable line_v2     : line;
  file input_file      : text; -- open read_mode is "input.txt";   --declare input file
  file out_file        : text open write_mode is "sim_generated_file/out.txt";
  file out_file_mult   : text open write_mode is "sim_generated_file/mult.txt";
  file out_file_shift  : text open write_mode is "sim_generated_file/shift.txt";
  variable a, b        : string(1 to 32);
  variable char        : character:='0';
  variable num_1       : std_logic_vector (31 downto 0); -- num_1 and num_2 are declared as variable
  variable num_2       : std_logic_vector (31 downto 0);
  variable count_value : integer := 0;
  variable count_value_shift : integer := 0;
  variable count_value2 : integer := 0;

  begin
  while (count_value < 9) loop
    file_open(input_file, "sim_input/input.txt", read_mode);
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
      mult_func <= std_logic_vector(to_unsigned(count_value, 4));
      wait for 1 ns;
      write(line_v, to_bstring(alu_function)& " " & to_bstring(a_in)& " " & to_bstring(b_in)& " " & to_bstring(c_alu));
      writeline(out_file, line_v);
      --write(line_v, to_bstring(reset_in)& " " &to_bstring(clk)& " " &to_bstring(mult_func)& " " & to_bstring(a_in)& " " & to_bstring(b_in)& " " & to_bstring(c_mult) & " " & to_bstring(pause_out));
      write(line_v, to_bstring(mult_func)& " " & to_bstring(a_in)& " " & to_bstring(b_in)& " " & to_bstring(c_mult) & " " & to_bstring(pause_out));
      writeline(out_file_mult, line_v);
      wait for 4 ns;
      exit f when endfile(input_file);
     end loop; -- end f loop

      write(line_v, string'(""));
      --write(line_v2, string'(""));
      writeline(out_file, line_v);
      writeline(out_file_mult, line_v);
      wait for 1 ns;
      file_close(input_file);
      count_value := count_value + 1;
      --count_value2 := count_value2 - 1;

    end loop ; -- end outer while loop


      while (count_value_shift < 4) loop
        file_open(input_file, "sim_input/input.txt", read_mode);
        g: loop
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

          value <= num_1;

          shift_func <= std_logic_vector(to_unsigned(count_value_shift, 2));
          wait for 1 ns;
          write(line_v, to_bstring(shift_func)& " " & to_bstring(shift_amount)& " " & to_bstring(value)& " " & to_bstring(b_in)& " " &to_bstring(c_shift));
          writeline(out_file_shift, line_v);
          wait for 4 ns;
          exit g when endfile(input_file);
        end loop; -- end g loop

          write(line_v, string'(""));
          writeline(out_file_shift, line_v);
          wait for 1 ns;
          file_close(input_file);
          count_value_shift := count_value_shift + 1;
        end loop ; -- end outer while loop

      --while (count_value2 < 9) loop
      --  file_open(input_file, "sim_input/input.txt", read_mode);
      --  multiplier: loop
      --    readline(input_file, line_num);
      --    read(line_num, a);
      --    read(line_num, b);

      --    for idx in 1 to 32 loop
      --         char := a(idx);
      --         if(char = '0') then
      --            num_1(32-idx) := '0';
      --         else
      --            num_1(32-idx) := '1';
      --         end if;
      --    end loop;

      --    for id in 1 to 32 loop
      --         char := b(id);
      --         if(char = '0') then
      --            num_2(32-id) := '0';
      --         else
      --            num_2(32-id) := '1';
      --         end if;
      --    end loop;

      --    a_in <= num_1;
      --    b_in <= num_2;
      --    mult_func <= std_logic_vector(to_unsigned(count_value2, 4));

      --    wait for 1 ns;
      --    write(line_v, to_bstring(reset_in)& " " &to_bstring(clk)& " " &to_bstring(mult_func)& " " & to_bstring(a_in)& " " & to_bstring(b_in)& " " & to_bstring(c_mult) & " " & to_bstring(pause_out));
      --    writeline(out_file_mult, line_v);

      --    wait for 4 ns;
      --    exit multiplier when endfile(input_file);
      --  end loop; -- end g loop

      --    write(line_v, string'(""));
      --    writeline(out_file_mult, line_v);
      --    wait for 1 ns;
      --    file_close(input_file);
      --    count_value2 := count_value2 + 1;
      --  end loop ; -- end outer while loop

      file_close(out_file);
      file_close(out_file_mult);
      file_close(out_file_shift);
      wait;

    end process;

  END;
