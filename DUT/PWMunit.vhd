LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;

---------------------------------------------------------
Entity PWMunit is
    GENERIC (n : INTEGER := 16);
    PORT (x,y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
        ALUFN: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        ena, rst, clk : IN STD_LOGIC ;        --ADDED CLOCK, RESET, ENABLE for PWM signal
        PWM_pulse: OUT STD_LOGIC );
end PWMunit ;
----------------------------------------------------------
ARCHITECTURE dtf of PWMunit IS
    SIGNAL counter : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    SIGNAL pwm_internal : STD_LOGIC := '0';
    SIGNAL cycle_toggle : STD_LOGIC := '0';  -- Toggles every full cycle for toggle mode
    SIGNAL prev_counter : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
BEGIN
    -- Counter process
    process(clk, rst)
    begin
        if rst = '1' then
            counter <= (others => '0');
            prev_counter <= (others => '0');
            cycle_toggle <= '0';
        elsif rising_edge(clk) then
            if ena = '1' then
                prev_counter <= counter;
                
                if counter >= y then  -- Reset when reaching y
                    counter <= (others => '0');
                    cycle_toggle <= not cycle_toggle;  -- Toggle the cycle indicator
                else
                    counter <= counter + 1;
                end if;
            end if;
        end if;
    end process;
    
    -- PWM control process
    process(clk, rst)
    begin
        if rst = '1' then
            pwm_internal <= '0';
        elsif rising_edge(clk) then
            if ena = '1' then
                case ALUFN is
                    when "000" =>  -- Set/Reset mode
                        if counter < x then
                            pwm_internal <= '0';  -- Output is 0 when counter < X
                        else
                            pwm_internal <= '1';  -- Output is 1 when counter ≥ X
                        end if;
                    
                    when "001" =>  -- Reset/Set mode
                        if counter < x then
                            pwm_internal <= '1';  -- Output is 1 when counter < X
                        else
                            pwm_internal <= '0';  -- Output is 0 when counter ≥ X
                        end if;
                    
                    when "010" =>  -- Toggle mode with alternating behavior
                        if cycle_toggle = '0' then
                            -- First cycle behavior
                            if counter < x then
                                pwm_internal <= '0';  -- Output is 0 when counter < X
                            else
                                pwm_internal <= '1';  -- Output is 1 when counter ≥ X
                            end if;
                        else
                            -- Second cycle behavior
                            if counter < x then
                                pwm_internal <= '1';  -- Output is 1 when counter < X
                            else
                                pwm_internal <= '0';  -- Output is 0 when counter ≥ X
                            end if;
                        end if;
                    
                    when others =>
                        null;  -- No change for other ALUFN values
                end case;
            end if;
        end if;
    end process;
    
    -- Output assignment
    PWM_pulse <= pwm_internal;
    
END dtf;