entity cnet is
  port(a,b: in std_logic;
        c: out std_logic);
end entity cnet;

architecture firsttry of cnet is
  signal x,y:std_logic;
begin
  c <= x nor y;
  x <= a and b;
  y <= a or b;
end architecture firsttry;